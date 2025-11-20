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

      udev = mkIf (isI3Enabled config) {
        enable = true;
        packages = [
          (pkgs.writeTextFile {
            name = "polybar-module-battery-combined-sh-udev-rules";
            destination = "/etc/udev/rules.d/95-polybar-battery.rules";
            text = ''
              SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.local.polybar-module-battery-combined-sh} --update"
              SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.local.polybar-module-battery-combined-sh} --update"
            '';
          })
        ];
      };

    };

    home-manager = {

      useGlobalPkgs = true;

      extraSpecialArgs = {
        inherit inputs outputs;
        user = {
          inherit (cfgMainUser)
            name
            full-name
            home-directory
            shell
            ;
        };
        theme = {
          desktop.bg = "${pkgs.local.wallpapers.duskglow}/image";
          lock-screen = {
            bg = "${pkgs.local.wallpapers.duskglow}/image-blurred";
            font-name = "Titillium";
            colors = rec {
              time = light;
              greeter = dark;

              light = "#ffffffff";
              dark = "#1d2021ee";
              ring = "#007c5bff";
              ring-hl = "#e3ac2dff";
              ring-bs = "#d1472fff";
              ring-sep = "#00000000";
            };
          };
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
