{
  pkgs-unstable,
  ...
}:
{
  home.packages = [
    pkgs-unstable.ghostty
  ];

  home.file = {
    ".config/ghostty/config" = {
      source = ../../../dotfiles/ghostty/config;
    };
  };
}
