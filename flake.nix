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

    # disko = builtins.fetchTarball {
    #   url = "https://github.com/nix-community/disko/archive/refs/tags/v1.12.0.tar.gz";
    #   sha256 = "sha256-eDoSOhxGEm2PykZFa/x9QG5eTH0MJdiJ9aR00VAofXE=";
    # };
    disko = {
      url = "github:nix-community/disko/v1.12.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      stateVersion = "25.05";

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = lib.genAttrs systems;
      system = builtins.elemAt systems 0;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      inherit lib;

      # home-manager configuration.
      # usage: home-manager --flake .#{user}
      homeConfigurations = {
        bow = lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              pkgs-unstable
              stateVersion
              ;
            userName = "bow";
          };
          modules = [ ./home/personal.nix ];
        };
      };

      # NixOS configuration.
      # usage: sudo nixos-rebuild switch --flake .#hostname
      nixosConfigurations = {
        duskglow = lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              pkgs-unstable
              stateVersion
              ;
          };
          modules = [ ./hosts/duskglow ];
        };
        vmlab = lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              pkgs-unstable
              stateVersion
              ;
          };
          modules = [ ./hosts/vmlab ];
        };
      };

      # Re-exported attributes.
      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # Reusable apps.
      apps = forAllSystems (system: {
        gen-machine-key =
          let
            pkgs = import nixpkgs { inherit system; };
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
      });

      # Flake conveniences.
      devShells = forAllSystems (system: {
        default =
          let
            pkgs = import nixpkgs { inherit system; };
          in
          pkgs.mkShellNoCC {
            packages = with pkgs; [
              sops
              ssh-to-age

              nixfmt-rfc-style
              deadnix
              statix
            ];
          };
      });
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
