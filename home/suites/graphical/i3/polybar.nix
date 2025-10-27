{
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.polybar.override {
      iwSupport = true;
      i3Support = true;
      pulseSupport = true;
    })
  ];

  home.file = {
    ".config/polybar" = {
      source = ../../../../dotfiles/polybar;
      recursive = true;
    };
  };
}
