{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixsys) mkOpt;
  libcfg = lib.nixsys.nixos;

  autologinEnabled = lib.hasAttr "auto-login" cfg.settings && cfg.settings.auto-login;
  mainUser = libcfg.getMainUser config;
  xorgEnabled = libcfg.isXorgEnabled config;

  cfg = mainUser.session.greetd;
in
{
  options.nixsys.users.main.session.greetd = {
    enable = lib.mkEnableOption "nixsys.users.main.session.greetd";
    settings = mkOpt types.attrs { } "greetd settings";
  };

  config = lib.mkIf cfg.enable {

    services.displayManager.autoLogin = lib.mkIf autologinEnabled {
      enable = true;
      user = mainUser.name;
    };

    services.greetd = lib.mkIf cfg.enable {
      enable = true;
      settings = {
        terminal.vt = 7;
        default_session = lib.mkIf xorgEnabled {
          command = "${pkgs.xorg.xinit}/bin/startx";
        };
        initial_session = lib.mkIf (autologinEnabled && xorgEnabled) {
          command = "${pkgs.xorg.xinit}/bin/startx";
          user = mainUser.name;
        };
      };
    };
  };
}
