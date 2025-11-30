{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nixsys.home.fonts;
in
{
  options.nixsys.home.fonts = {
    enable = lib.mkEnableOption "nixsys.home.fonts" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      fontconfig = {
        enable = true;
        defaultFonts.monospace = [ "Iosevka SS03" ];
      };
    };

    home.packages = with pkgs; [
      (iosevka-bin.override { variant = "SS03"; })
      nerd-fonts.droid-sans-mono
      nerd-fonts.inconsolata
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-sans
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      siji

      unstable.font-awesome

      local.awesome-terminal-fonts
      local.titillium-fonts
    ];
  };
}
