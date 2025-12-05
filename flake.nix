{
  description = "Nix-based configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/v1.12.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-generators,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      inherit (lib.nixsys.pub) forEachSystem;

      lib = nixpkgs.lib.extend (
        final: _prev: {
          nixsys = import ./lib {
            inherit inputs outputs;
            lib = final;
          };
        }
      );

      forEachSupportedSystem = forEachSystem [
        "x86_64-linux"
        "aarch64-linux"
      ];

      user = {
        name = "default";
        full-name = "Default User";
        email = "default@email.com";
        city = "Reykjavik";
        timezone = "UTC";
      };
    in
    {
      lib = lib.nixsys.pub;

      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos/mod.nix { inherit inputs outputs lib; };

      homeManagerModules = import ./modules/home/mod.nix { inherit inputs outputs lib; };

      packages = forEachSupportedSystem (
        { pkgs }:
        import ./packages { inherit pkgs; }
        // {
          duskglow-qcow = nixos-generators.nixosGenerate {
            inherit lib;
            inherit (pkgs.stdenv.hostPlatform) system;
            format = "qcow-efi";
            modules = [
              {
                nix.registry.nixpkgs.flake = nixpkgs;
                virtualisation.vmVariant.virtualisation = {
                  diskSize = 80 * 1024;
                  memSize = 8 * 1024;
                  writableStoreUseTmpfs = false;
                };
              }
              ./hosts/duskglow
              ./machines/duskglow-qemu/hardware.nix
              ./machines/duskglow-qemu/config.nix
              ./machines/duskglow-qemu/secrets.nix
            ];
            specialArgs = {
              inherit
                inputs
                outputs
                lib
                user
                ;
              hostname = "duskglow";
            };
          };
        }
      );

      # NixOS configuration examples.
      # usages:
      #   - nix build .#nixosConfigurations.{name}.config.system.build.toplevel
      #   - nix run .#build-os -- {name}
      nixosConfigurations = {
        duskglow-qemu = lib.nixsys.mkSystem {
          inherit user;
          hostModuleName = "duskglow";
          modules = [
            ./machines/duskglow-qemu/hardware.nix
            ./machines/duskglow-qemu/disk.nix
            ./machines/duskglow-qemu/config.nix
            ./machines/duskglow-qemu/secrets.nix
          ];
        };
      };

      apps = forEachSupportedSystem (
        { pkgs }:
        {
          build-os =
            let
              script-pkg = pkgs.writeShellScriptBin "build-os" ''
                set -e

                if [ -z "''${1}" ]; then
                  ${pkgs.coreutils}/bin/echo "Usage: nix run .#build-os -- <nixosConfiguration>"
                  exit 1
                fi

                CONFIG="$1"

                ${pkgs.coreutils}/bin/echo "Building configuration: ''$CONFIG"

                nix build ".#nixosConfigurations.''${CONFIG}.config.system.build.toplevel"

                ${pkgs.coreutils}/bin/echo "Build complete. See ./result"
              '';
            in
            {
              type = "app";
              program = "${script-pkg}/bin/build-os";
            };
        }
      );

      # Flake conveniences.
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShellNoCC {
            packages = [
              pkgs.age
              pkgs.home-manager
              pkgs.sops
              pkgs.ssh-to-age

              pkgs.deadnix
              pkgs.nixfmt-rfc-style
              pkgs.statix
            ];
          };
        }
      );

      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt-rfc-style);
    };
}
