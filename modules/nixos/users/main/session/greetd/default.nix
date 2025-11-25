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

  user = getMainUser config;
  cfg = user.session.greetd;

  autologinEnabled = hasAttr "auto-login" cfg.settings && cfg.settings.auto-login;
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
      user = user.name;
    };

    services.greetd = mkIf cfg.enable {
      enable = true;
      settings = {
        terminal.vt = 7;
        default_session = mkIf (isXorgEnabled config) {
          command = "${pkgs.xorg.xinit}/bin/startx";
        };
        initial_session = mkIf (autologinEnabled && (isXorgEnabled config)) {
          command = "${pkgs.xorg.xinit}/bin/startx";
          user = user.name;
        };
      };
    };
  };
}
