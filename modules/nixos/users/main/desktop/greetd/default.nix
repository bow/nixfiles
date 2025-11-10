{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    hasAttr
    mkEnableOption
    mkIf
    types
    ;
  inherit (lib.nixsys) mkOpt;

  cfgUsers = config.nixsys.users;
  cfg = config.nixsys.users.main.desktop.greetd;

  xorgEnabled = cfgUsers.main.desktop.i3.enable;
  autologinEnabled = hasAttr "autoLogin" cfg.settings && cfg.settings.autoLogin;
in
{
  options.nixsys.users.main.desktop.greetd = {
    enable = mkEnableOption "Enable this module";
    settings = mkOpt types.attrs { } "greetd settings";
  };

  config = mkIf cfg.enable {

    services.displayManager.autoLogin = mkIf autologinEnabled {
      enable = true;
      user = cfgUsers.main.name;
    };

    services.greetd = mkIf cfg.enable {
      enable = true;
      settings = {
        terminal.vt = 7;
        default_session = mkIf xorgEnabled {
          command = "${pkgs.xorg.xinit}/bin/startx";
        };
        initial_session = mkIf (autologinEnabled && xorgEnabled) {
          command = "${pkgs.xorg.xinit}/bin/startx";
          user = cfgUsers.main.name;
        };
      };
    };
  };
}
