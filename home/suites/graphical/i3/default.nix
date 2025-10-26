{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
let
  inherit (lib) types;
  cfg = config.local.i3;
in
{
  imports = [
    ./polybar.nix
  ];

  options = {
    local.i3.modifierKey = lib.mkOption {
      type = types.str;
      default = "Mod4";
      description = "Mod key for i3";
    };
  };

  config = {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
      config = rec {
        modifier = cfg.modifierKey;
        keybindings = {
          "${modifier}+Return" = "exec ${pkgs.ghostty}/bin/ghostty";
          "${modifier}+backslash" = "exec ${pkgs.xfce.thunar}/bin/thunar";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+Tab" = "exec ${pkgs-unstable.rofi}/bin/rofi -show combi";
        };
      };
    };

    home.packages = [
      # Image viewer.
      pkgs.feh

      # Screnshot tool.
      pkgs.maim

      # Temperature-based screen light adjuster.
      pkgs.redshift

      # Launcher.
      pkgs-unstable.rofi
      pkgs-unstable.rofi-pass

      # File explorer.
      pkgs.xfce.thunar
    ];

    home.file = {
      ".xinitrc".source = ../../../../dotfiles/xorg/.xinitrc;
      ".xmodmaprc".source = ../../../../dotfiles/xorg/.xmodmaprc;
      ".Xdefaults".source = ../../../../dotfiles/xorg/.Xdefaults;
    };
  };
}
