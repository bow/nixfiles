{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.nixsys.nixos) hasProfileWorkstation;
in
{
  config = mkIf (hasProfileWorkstation config) {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
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
      fontconfig.defaultFonts = {
        monospace = [ "Iosevka SS03" ];
      };
    };
  };
}
