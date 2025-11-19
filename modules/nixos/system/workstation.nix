{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.nixsys.nixos) hasProfileWorkstation;
in
{
  config = mkIf (hasProfileWorkstation config) {

    services = {

      udev.extraRules = ''
        SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.local.polybar-module-battery-combined-sh} --update"
        SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.local.polybar-module-battery-combined-sh} --update"
      '';

      upower.enable = true;
    };
  };
}
