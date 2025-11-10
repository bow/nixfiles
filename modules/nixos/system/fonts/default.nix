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
  config =
    mkIf (config.nixsys.system.kind == "workstation") {
      fonts = {
        enableDefaultPackages = true;
        packages = [
          pkgs.nerd-fonts.droid-sans-mono
          pkgs.nerd-fonts.inconsolata
          pkgs.nerd-fonts.ubuntu
          pkgs.nerd-fonts.ubuntu-sans
          (pkgs.iosevka-bin.override { variant = "SS03"; })
          pkgs.local.titillium-fonts
        ];
        fontconfig.defaultFonts = {
          monospace = [ "Iosevka SS03" ];
        };
      };
    };
}
