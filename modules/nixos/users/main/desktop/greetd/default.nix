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
    mkOption
    types
    ;
  inherit (lib.nixsys) mkOpt;

  cfgMainUser = config.nixsys.users.main;
  cfg = cfgMainUser.desktop.greetd;

  xorgEnabled = cfgMainUser.desktop.i3.enable;
  autologinEnabled = hasAttr "auto-login" cfg.settings && cfg.settings.auto-login;
in
{
  options.nixsys.users.main.desktop.greetd = mkOption {
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.users.main.desktop.greetd";
        settings = mkOpt types.attrs { } "greetd settings";
      };
    };
  };

  config = mkIf cfg.enable {

    services.displayManager.autoLogin = mkIf autologinEnabled {
      enable = true;
      user = cfgMainUser.name;
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
          user = cfgMainUser.name;
        };
      };
    };
  };
}
