{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  inherit (lib.nixsys.home) isGhosttyEnabled;

  ghosttyEnabled = isGhosttyEnabled config;

  cfg = config.nixsys.home.programs.rofi;
in
{
  options.nixsys.home.programs.rofi = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.programs.rofi" // {
          default = config.nixsys.home.desktop.i3.enable;
        };
      };
    };
  };

  config = mkIf cfg.enable {

    programs.rofi = {
      enable = true;
      terminal = if ghosttyEnabled then "ghostty" else null;
      cycle = true;
      extraConfig = {
        modi = "combi";
        combi-modi = "drun,window";
        display-ssh = "";
        display-run = "";
        display-drun = "⬢";
        display-window = "⮼";
        display-combi = "";

        drun-match-fields = "name,exec";
        drun-display-format = "{name}";
        window-format = "{w} · {t}";
        show-icons = false;

        auto-select = false;
        cycle = true;
        matching = "normal";
        scroll-method = 1;
      };

      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
        in
        {
          "*" = {
            font = "Titillium Lt 21";

            highlight = mkLiteral "bold";
            scrollbar = mkLiteral "true";

            bg = mkLiteral "#202020";
            fg-light = mkLiteral "#e8e8d3";
            fg-dark = mkLiteral "#5f676a";
            active = mkLiteral "#007c5b";
            urgent = mkLiteral "#e3ac2d";

            normal-background = mkLiteral "@bg";
            normal-foreground = mkLiteral "@fg-dark";
            alternate-normal-background = mkLiteral "@bg";
            alternate-normal-foreground = mkLiteral "@fg-dark";
            selected-normal-background = mkLiteral "@bg";
            selected-normal-foreground = mkLiteral "@fg-light";

            active-background = mkLiteral "@bg";
            active-foreground = mkLiteral "@active";
            alternate-active-background = mkLiteral "@bg";
            alternate-active-foreground = mkLiteral "@active";
            selected-active-background = mkLiteral "@active";
            selected-active-foreground = mkLiteral "@fg-light";

            urgent-background = mkLiteral "@bg";
            urgent-foreground = mkLiteral "@urgent";
            alternate-urgent-background = mkLiteral "@bg";
            alternate-urgent-foreground = mkLiteral "@urgent";
            selected-urgent-background = mkLiteral "@urgent";
            selected-urgent-foreground = mkLiteral "@fg-light";
          };
          window = {
            width = mkLiteral "36%";
            height = mkLiteral "32%";
            background-color = mkLiteral "@normal-background";
            border = 0;
            padding = 2;
          };
          mainbox = {
            border = 0;
            padding = 0;
            background-color = mkLiteral "@normal-background";
          };
          message = {
            border = mkLiteral "2px 0 0";
            border-color = mkLiteral "@selected-normal-foreground";
            padding = mkLiteral "1px";
          };
          textbox = {
            highlight = mkLiteral "@highlight";
            text-color = mkLiteral "@normal-foreground";
          };
          listview = {
            border = mkLiteral "1px solid 0 0";
            margin = mkLiteral "6px";
            padding = mkLiteral "8px 0 -5px";
            spacing = mkLiteral "1px";
            scrollbar = mkLiteral "@scrollbar";
            border-color = mkLiteral "@selected-normal-foreground";
            background-color = mkLiteral "inherit";
          };
          scrollbar = {
            width = mkLiteral "4px";
            border = 0;
            handle-color = mkLiteral "@selected-normal-foreground";
            handle-width = mkLiteral "2px";
            padding = 0;
            background-color = mkLiteral "inherit";
          };
          mode-switcher = {
            border = mkLiteral "2px 0 0";
            border-color = mkLiteral "@selected-normal-foreground";
          };
          inputbar = {
            spacing = 0;
            background-color = mkLiteral "@normal-background";
            text-color = mkLiteral "@normal-foreground";
            padding = mkLiteral "12px 4px 0px 4px";
            children = builtins.map mkLiteral [
              "prompt"
              "textbox-prompt-sep"
              "entry"
              "case-indicator"
            ];
          };
          "case-indicator, entry, prompt, button" = {
            spacing = 0;
            text-color = mkLiteral "@urgent";
            background-color = mkLiteral "inherit";
          };
          entry = {
            placeholder = "";
            placeholder-color = mkLiteral "@normal-foreground";
            expand = true;
            font = "Titillium Lt 19";
          };
          textbox-prompt-sep = {
            expand = false;
            str = "";
            text-color = mkLiteral "@urgent";
            margin = mkLiteral "0 0.1em 0 0";
          };
          element = {
            border = 0;
            padding = mkLiteral "0 4px 10px 4px";
            background-color = mkLiteral "inherit";
            children = [ (mkLiteral "element-text") ];
          };
          "element-text, element-icon" = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          element-text = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          "element.normal.normal" = {
            background-color = mkLiteral "@normal-background";
            text-color = mkLiteral "@normal-foreground";
          };
          "element.normal.urgent" = {
            background-color = mkLiteral "@urgent-background";
            text-color = mkLiteral "@urgent-foreground";
          };
          "element.normal.active" = {
            background-color = mkLiteral "@active-background";
            text-color = mkLiteral "@active-foreground";
          };
          "element.selected.normal" = {
            background-color = mkLiteral "@selected-normal-background";
            text-color = mkLiteral "@selected-normal-foreground";
          };
          "element.selected.urgent" = {
            background-color = mkLiteral "@selected-urgent-background";
            text-color = mkLiteral "@selected-urgent-foreground";
          };
          "element.selected.active" = {
            background-color = mkLiteral "@selected-active-background";
            text-color = mkLiteral "@selected-active-foreground";
          };
          "element.alternate.normal" = {
            background-color = mkLiteral "@alternate-normal-background";
            text-color = mkLiteral "@alternate-normal-foreground";
          };
          "element.alternate.urgent" = {
            background-color = mkLiteral "@alternate-urgent-background";
            text-color = mkLiteral "@alternate-urgent-foreground";
          };
          "element.alternate.active" = {
            background-color = mkLiteral "@alternate-active-background";
            text-color = mkLiteral "@alternate-active-foreground";
          };
        };

      pass.enable = true;
    };
  };
}
