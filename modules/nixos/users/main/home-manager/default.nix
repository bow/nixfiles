{
  config,
  lib,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib) types;

  cfgMainUser = config.nixsys.users.main;
  cfg = cfgMainUser.home-manager;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.nixsys.users.main.home-manager = lib.mkOption {
    default = { };
    type = types.submodule {
      freeformType = types.attrsOf types.anything;
      options = {
        enable = lib.mkEnableOption "nixsys.users.main.home-manager";
        system = lib.mkOption {
          default = { };
          type = types.attrsOf types.anything;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {

    home-manager = {

      useGlobalPkgs = true;

      backupFileExtension = "hm-backup";

      extraSpecialArgs = {
        inherit inputs outputs;
        user = {
          inherit (cfgMainUser)
            name
            email
            full-name
            home-directory
            shell
            ;
        };
        asStandalone = false;
      };

      users.${cfgMainUser.name} = {
        imports = [
          outputs.homeManagerModules.all
          ./home.nix
        ];

        # Everything in cfg that is not `enable` is meant for nixsys.home.
        nixsys.home = removeAttrs cfg [ "enable" ] // {
          # Façade for system-level config.
          system = {
            docker.enable = config.nixsys.system.virtualization.docker.enable;
          };
        };
      };
    };
  };
}
