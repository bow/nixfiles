{
  description = "Nix-based configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib.extend (
        final: _prev: {
          nixsys = import ./lib {
            inherit inputs;
            lib = final;
          };
        }
      );

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forEachSupportedSystem =
        f:
        lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      inherit lib;

      # home-manager configuration.
      # usage: home-manager --flake .#{user}
      homeConfigurations = {
        bow = lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs outputs lib;
            user = rec {
              name = "bow";
              home-directory = "/home/${name}";
            };
            asStandalone = true;
          };
          modules = [ ./modules/nixos/users/main/home-manager/home.nix ];
        };
      };

      # NixOS configuration.
      # usage: sudo nixos-rebuild switch --flake .#machinename
      nixosConfigurations = {
        duskglow = lib.nixosSystem {
          specialArgs = { inherit inputs outputs lib; };
          modules = [ ./machines/duskglow ];
        };
        # ISO installation media for nixos-anywhere
        # Build with: nix build .#nixosConfigurations.iso.config.system.build.isoImage
        # Then run with: nix run github:nix-community/nixos-anywhere -- --flake .#vmlab --target-host <user>@<host>
        iso = lib.nixosSystem {
          modules = [
            (
              { pkgs, modulesPath, ... }:
              {
                imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
                nixpkgs.hostPlatform = "x86_64-linux";
                networking.networkmanager.enable = true;
                networking.wireless.enable = false;
                systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
                users.users.root.openssh.authorizedKeys.keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILetxdkGYGooOnymLSctz3B+QxTGonnAwQbSwFoIa9UR openpgp:0xBBA92D16"
                ];
              }
            )
          ];
        };
        vmlab = lib.nixosSystem {
          specialArgs = { inherit inputs outputs lib; };
          modules = [ ./machines/vmlab ];
        };
      };

      # Re-exported attributes.
      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos/mod.nix { inherit inputs outputs lib; };
      homeManagerModules = import ./modules/home;

      # Reusable apps.
      apps = forEachSupportedSystem (
        { pkgs, ... }:
        {
          gen-machine-key =
            let
              pkgGenMachineKey = pkgs.writeShellScriptBin "gen-machine-key" ''
                set -eu
                OUT=''${1:-/mnt/persist/machine-key.txt}
                mkdir -p ''$(dirname ''${OUT})
                ${pkgs.age}/bin/age-keygen -o ''${OUT}
                chmod 600 ''${OUT}
                echo "Path: ''${OUT}"
              '';
            in
            {
              type = "app";
              program = "${pkgGenMachineKey}/bin/gen-machine-key";
            };
        }
      );

      # Flake conveniences.
      devShells = forEachSupportedSystem (
        { pkgs, ... }:
        {
          default =
            let
              localScripts = [
                (pkgs.writeShellApplication {
                  name = "nxf-build-iso";
                  text = ''
                    nix build .#nixosConfigurations.iso.config.system.build.isoImage
                  '';
                })
              ];
            in
            pkgs.mkShellNoCC {
              packages =
                with pkgs;
                [
                  age
                  sops
                  ssh-to-age

                  nixfmt-rfc-style
                  deadnix
                  statix
                ]
                ++ localScripts;
            };
        }
      );
      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt-rfc-style);
    };
}
