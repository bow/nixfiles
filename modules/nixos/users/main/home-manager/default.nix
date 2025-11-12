{
  config,
  lib,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfgUsers = config.nixsys.users;
  cfg = config.nixsys.users.main.home-manager;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.nixsys.users.main.home-manager = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "Enable this module";
        desktop = mkOption {
          type = types.submodule {
            options = { };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs = {
        inherit inputs outputs;
        user = {
          inherit (cfgUsers.main) name home-directory;
        };
        asStandalone = false;
      };
      users.${cfgUsers.main.name}.imports = [
        outputs.homeManagerModules.all
        ./home.nix
      ];
    };
  };
}
