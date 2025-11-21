{
  pkgs,
  ...
}:
with pkgs;
{
  awesome-terminal-fonts = callPackage ./awesome-terminal-fonts { };
  polybar-module-battery-combined-sh = callPackage ./polybar-module-battery-combined-sh { };
  titillium-fonts = callPackage ./titillium-fonts { };
  wallpapers = callPackage ./wallpapers { };
}
