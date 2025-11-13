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
    removeAttrs
    types
    ;

  cfgUsers = config.nixsys.users;
  cfg = cfgUsers.main.home-manager;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.nixsys.users.main.home-manager = mkOption {
    default = { };
    type = types.submodule {
      freeformType = types.attrsOf types.anything;
      options = {
        enable = mkEnableOption "Enable this module";
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

      users.${cfgUsers.main.name} = {
        imports = [
          outputs.homeManagerModules.all
          ./home.nix
        ];

        # Everything in cfg that is not `enable` is meant for nixsys.home.
        nixsys.home = removeAttrs cfg [ "enable" ];
      };
    };
  };
}
