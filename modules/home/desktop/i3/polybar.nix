{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.nixsys.home.desktop.i3;
in
{
  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.polybar.override {
        iwSupport = true;
        i3Support = true;
        pulseSupport = true;
      })
    ];

    home.file = {
      ".config/polybar" = {
        source = ../../../../dotfiles/polybar;
        recursive = true;
      };
    };
  };
}
