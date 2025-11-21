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
  inherit (lib.nixsys.nixos) getHomeConfig getMainUserName;

  cfg = config.nixsys.users.main.session.i3;
  homeCfg = getHomeConfig config;
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

    # FIXME: Think of a better way to expose the home-defined lock script.
    systemd =
      let
        templateName = "sleep";
      in
      mkIf (homeCfg != null && homeCfg.desktop.i3.enable) {
        services."${templateName}@" = {
          enable = true;
          description = "i3 screen locker script template ";
          wantedBy = [ "sleep.target" ];
          before = [ "sleep.target" ];

          serviceConfig = {
            User = "%I";
            Type = "forking";
            Environment = [
              "DISPLAY=:0"
              "NOFORK=0"
            ];
            ExecStart = "${homeCfg.desktop.i3.lock-script}";
          };
        };
        services."${templateName}@${getMainUserName config}" = {
          wantedBy = [ "sleep.target" ];
          before = [ "sleep.target" ];
          overrideStrategy = "asDropin";
        };
      };
  };
}
