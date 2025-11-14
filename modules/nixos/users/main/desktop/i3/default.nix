{
  config,
  lib,
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
  };
}
