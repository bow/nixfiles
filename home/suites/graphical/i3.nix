{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;
    config = rec {
      modifier = "Mod4";
      keybindings = {
        "${modifier}+Return" = "exec ${pkgs-unstable.ghostty}/bin/ghostty";
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

    # Status bar.
    pkgs-unstable.polybar

    # Temperature-based screen light adjuster.
    pkgs.redshift

    # Launcher.
    pkgs-unstable.rofi
    pkgs-unstable.rofi-pass

    # File explorer.
    pkgs.xfce.thunar
  ];

  home.file = {
    ".xinitrc".source = ../../../dotfiles/xorg/.xinitrc;
    ".xmodmaprc".source = ../../../dotfiles/xorg/.xmodmaprc;
    ".Xdefaults".source = ../../../dotfiles/xorg/.Xdefaults;
  };
}
