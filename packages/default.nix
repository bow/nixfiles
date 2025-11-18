{
  pkgs,
  ...
}:
{
  titillium-fonts = pkgs.callPackage ./titillium-fonts { };
  awesome-terminal-fonts = pkgs.callPackage ./awesome-terminal-fonts { };
  polybar-module-battery-combined-script = pkgs.callPackage ./polybar-module-battery-combined { };
}
