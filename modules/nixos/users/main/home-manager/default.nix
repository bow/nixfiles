{
  config,
  lib,
  pkgs,
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
  inherit (lib.nixsys.nixos) isI3Enabled;

  cfgMainUser = config.nixsys.users.main;
  cfg = cfgMainUser.home-manager;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.nixsys.users.main.home-manager = mkOption {
    type = types.submodule {
      freeformType = types.attrsOf types.anything;
      options = {
        enable = mkEnableOption "nixsys.users.main.home-manager";
      };
    };
  };

  config = mkIf cfg.enable {

    services = {
      upower.enable = true;

      udev.extraRules = mkIf (isI3Enabled config) ''
        SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.local.polybar-module-battery-combined-sh} --update"
        SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.local.polybar-module-battery-combined-sh} --update"
      '';
    };

    home-manager = {

      useGlobalPkgs = true;

      extraSpecialArgs = {
        inherit inputs outputs;
        user = {
          inherit (cfgMainUser) name home-directory shell;
        };
        asStandalone = false;
      };

      users.${cfgMainUser.name} = {
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
