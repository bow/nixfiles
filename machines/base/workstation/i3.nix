{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
  cfg = config.local.i3;
in
{
  options = {
    local.i3.autoLoginUserName = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "If specified, enable auto login to i3 and log in as the specified user.";
    };
  };

  config = {
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

    services.displayManager = {
      defaultSession = "none+i3";
      autoLogin = {
        enable = cfg.autoLoginUserName != null;
        user = cfg.autoLoginUserName;
      };
    };

    programs.i3lock.enable = true;

    security.pam.services = {
      i3lock-color.enable = true;
    };
  };
}
