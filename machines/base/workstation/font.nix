{
  pkgs,
  ...
}:
{
  fonts =
    # let
    #   # nerdFonts = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    # in
    {
      enableDefaultPackages = true;
      packages = [
        # (pkgs.nerd-fonts.override { fonts = nerdFontsNames; })

        pkgs.nerd-fonts.droid-sans-mono
        pkgs.nerd-fonts.inconsolata
        pkgs.nerd-fonts.ubuntu
        pkgs.nerd-fonts.ubuntu-sans
        (pkgs.iosevka-bin.override { variant = "SS03"; })
      ];
      fontconfig.defaultFonts = {
        monospace = [ "Iosevka SS03" ];
      };
    };
}
