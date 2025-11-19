{
  pkgs,
  ...
}:
{
  titillium-fonts = pkgs.callPackage ./titillium-fonts { };
  awesome-terminal-fonts = pkgs.callPackage ./awesome-terminal-fonts { };
  polybar-module-battery-combined-sh = pkgs.callPackage ./polybar-module-battery-combined-sh { };
}
