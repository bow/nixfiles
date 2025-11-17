{
  pkgs,
  ...
}:
{
  titillium-fonts = pkgs.callPackage ./titillium-fonts { };
  awesome-terminal-fonts = pkgs.callPackage ./awesome-terminal-fonts { };
}
