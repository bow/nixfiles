{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (config.nixsys.system.profile == "workstation") {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.droid-sans-mono
        nerd-fonts.inconsolata
        nerd-fonts.ubuntu
        nerd-fonts.ubuntu-sans
        (iosevka-bin.override { variant = "SS03"; })
        local.titillium-fonts
      ];
      fontconfig.defaultFonts = {
        monospace = [ "Iosevka SS03" ];
      };
    };
  };
}
