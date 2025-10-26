{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.ghostty ];

  home.file = {
    ".config/ghostty/config" = {
      source = ../../../dotfiles/ghostty/config;
    };
  };
}
