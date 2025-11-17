{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.nixsys.users.main.desktop.i3;
in
{
  options.nixsys.users.main.desktop.i3 = mkOption {
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.user.main.desktop.i3";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.pathsToLink = [ "/libexec" ];

    services.xserver = {
      enable = true;
      autorun = false;
      displayManager.startx = {
        enable = true;
      };
      desktopManager = {
        xterm.enable = false;
      };
      windowManager.i3 = {
        enable = true;
      };
    };

    services.displayManager.defaultSession = "none+i3";

    programs.i3lock.enable = true;

    security.pam.services.i3lock-color.enable = true;

    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.local.polybar-module-battery-combined} --update"
      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.local.polybar-module-battery-combined} --update"
    '';
  };
}
