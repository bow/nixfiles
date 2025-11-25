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
  inherit (lib.nixsys.nixos) getMainUser isXorgEnabled;

  autologinEnabled = hasAttr "auto-login" cfg.settings && cfg.settings.auto-login;
  mainUser = getMainUser config;
  xorgEnabled = isXorgEnabled config;

  cfg = mainUser.session.greetd;
in
{
  options.nixsys.users.main.session.greetd = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.users.main.session.greetd";
        settings = mkOpt types.attrs { } "greetd settings";
      };
    };
  };

  config = mkIf cfg.enable {

    services.displayManager.autoLogin = mkIf autologinEnabled {
      enable = true;
      user = mainUser.name;
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
          user = mainUser.name;
        };
      };
    };
  };
}
