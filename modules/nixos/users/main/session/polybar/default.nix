{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.nixsys.users.main.session.polybar;
  i3Cfg = config.nixsys.users.main.session.i3;
in
{
  options.nixsys.users.main.session.polybar = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.user.main.session.polybar" // {
          default = i3Cfg.enable;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      udev = {
        enable = mkDefault true;
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

      upower.enable = true;
    };
  };
}
