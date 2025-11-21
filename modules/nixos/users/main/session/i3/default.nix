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

  cfg = config.nixsys.users.main.session.i3;
in
{
  options.nixsys.users.main.session.i3 = mkOption {
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.user.main.session.i3";
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

    programs.i3lock = {
      enable = true;
      package = pkgs.i3lock-color;
    };

    security.pam.services.i3lock-color.enable = true;
  };
}
