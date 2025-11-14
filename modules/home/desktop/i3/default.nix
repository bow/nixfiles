{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (lib.nixsys) mkOpt;

  cfg = config.nixsys.home.desktop.i3;
in
{
  imports = [
    ./polybar.nix
  ];

  options.nixsys.home.desktop.i3 = mkOption {
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.desktop.i3";
        mod-key = mkOpt types.str "Mod4" "Mod key for i3";
      };
    };
  };

  config = mkIf cfg.enable {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
      config =
        let
          pallete = {
            focusedFG = "#ffffff";
            focusedBG = "#184a53";
            focusedInactiveFG = "#a89984";
            focusedInactiveBG = "#3c3836";
            unfocusedFG = "#665c54";
            unfocusedBG = "#282828";
            urgentFG = "#151515";
            urgentBG = "#e3ac2d";
            barBG = "#151515";
            barFG = "#bdbeab";
          };
        in
        rec {
          modifier = cfg.mod-key;
          colors = {
            focused = {
              border = pallete.focusedBG;
              background = pallete.focusedBG;
              text = pallete.focusedFG;
              indicator = pallete.focusedInactiveBG;
              childBorder = "";
            };
            focusedInactive = {
              border = pallete.focusedInactiveBG;
              background = pallete.focusedInactiveBG;
              text = pallete.focusedInactiveFG;
              indicator = pallete.focusedBG;
              childBorder = pallete.focusedInactiveBG;
            };
            unfocused = {
              border = "#222222";
              background = pallete.unfocusedBG;
              text = pallete.unfocusedFG;
              indicator = pallete.unfocusedBG;
              childBorder = pallete.unfocusedBG;
            };
            urgent = {
              border = pallete.urgentBG;
              background = pallete.urgentBG;
              text = pallete.urgentFG;
              indicator = pallete.urgentBG;
              childBorder = pallete.urgentBG;
            };
            placeholder = {
              border = "#000000";
              background = pallete.focusedInactiveBG;
              text = pallete.focusedInactiveFG;
              indicator = "#000000";
              childBorder = pallete.focusedInactiveBG;
            };
          };
          fonts = {
            names = [ "DroidSansMono Nerd Font" ];
            size = "8";
          };
          floating = { inherit modifier; };
          gaps = {
            inner = 2;
            outer = 23;
            bottom = 22;
            top = 0;
          };
          modes = {
            resize = {
              "h" = "resize shrink width 10 px or 10 ppt";
              "j" = "resize grow height 10 px or 10 ppt";
              "k" = "resize shrink height 10 px or 10 ppt";
              "l" = "resize grow width 10 px or 10 ppt";

              "Right" = "resize shrink width 10 px or 10 ppt";
              "Up" = "resize grow height 10 px or 10 ppt";
              "Down" = "resize shrink height 10 px or 10 ppt";
              "Left" = "resize grow width 10 px or 10 ppt";

              "Return" = ''mode "default"'';
              "Escape" = ''mode "default"'';
            };
          };
          window = {
            hideEdgeBorders = "smart";
            commands =
              builtins.map
                (class: {
                  criteria = { inherit class; };
                  command = "border pixel 0";
                })
                [
                  "ghostty"
                  "Zathura"
                  "firefox"
                  "google-chrome"
                ];
          };
          defaultWorkspace = keybindings."${modifier}+2";
          keybindings = {
            # Navigation.
            "${modifier}+j" = "focus left";
            "${modifier}+k" = "focus down";
            "${modifier}+l" = "focus up";
            "${modifier}+semicolon" = "focus right";
            "${modifier}+Left" = "focus left";
            "${modifier}+Down" = "focus down";
            "${modifier}+Up" = "focus up";
            "${modifier}+Right" = "focus right";

            # Move windows.
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";
            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";

            # Split windows.
            "${modifier}+h" = "split h";
            "${modifier}+v" = "split v";

            # Enter fullscreen mode for the focused container.
            "${modifier}+f" = "fullscreen toggle";

            # Change container layout (stacked, tabbed, toggle split).
            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";

            # Toggle tiling / floating.
            "${modifier}+Shift+space" = "floating toggle";

            # Change focus between tiling / floating windows.
            "${modifier}+space" = "focus mode_toggle";

            # Focus the parent container.
            "${modifier}+a" = "focus parent";

            # Switch to workspace.
            "${modifier}+1" = "workspace 1:";
            "${modifier}+2" = "workspace 2:";
            "${modifier}+3" = "workspace 3:";
            "${modifier}+4" = "workspace 4:";
            "${modifier}+5" = "workspace 5:";
            "${modifier}+6" = "workspace 6:•";
            "${modifier}+7" = "workspace 7:•";
            "${modifier}+8" = "workspace 8:•";
            "${modifier}+9" = "workspace 9:•";
            "${modifier}+0" = "workspace 10:•";
            "${modifier}+p" = "workspace 11:";
            "${modifier}+c" = "workspace 12:";
            "${modifier}+b" = "workspace 13:";

            # Move focused container to workspace.
            "${modifier}+Shift+1" = "move container to workspace 1:";
            "${modifier}+Shift+2" = "move container to workspace 2:";
            "${modifier}+Shift+3" = "move container to workspace 3:";
            "${modifier}+Shift+4" = "move container to workspace 4:";
            "${modifier}+Shift+5" = "move container to workspace 5:";
            "${modifier}+Shift+6" = "move container to workspace 6:•";
            "${modifier}+Shift+7" = "move container to workspace 7:•";
            "${modifier}+Shift+8" = "move container to workspace 8:•";
            "${modifier}+Shift+9" = "move container to workspace 9:•";
            "${modifier}+Shift+0" = "move container to workspace 10:•";
            "${modifier}+Shift+p" = "move container to workspace 11:";
            "${modifier}+Shift+c" = "move container to workspace 12:";
            "${modifier}+Shift+b" = "move container to workspace 13:";

            # Move between workspaces.
            "${modifier}+Prior" = "workspace prev";
            "${modifier}+Next" = "workspace next";
            "${modifier}+Shift+n" = "move workspace to output next";
            "${modifier}+n" = "focus output next";

            # Reload the configuration file.
            "${modifier}+Shift+o" = "reload";

            # Restart i3 inplace (preserves layout/session, can be used to upgrade i3)
            "${modifier}+Shift+r" = "restart";

            # Exit i3 (logs out of an X session).
            "${modifier}+Shift+e" = ''
              exec "${pkgs.i3}/bin/i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' '${pkgs.i3}/bin/i3-msg exit'"
            '';

            # Shortcuts.
            "${modifier}+Shift+q" = "kill";
            "${modifier}+r" = ''mode "resize"'';

            "${modifier}+Return" = "exec ${pkgs.ghostty}/bin/ghostty";
            "${modifier}+backslash" = "exec ${pkgs.xfce.thunar}/bin/thunar";
            "${modifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show combi";
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
      pkgs.rofi
      pkgs.rofi-pass

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
