{
  pkgs,
  ...
}:
{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
  };

  home.file = {
    ".config/i3/config" = {
      source = ../../../dotfiles/i3/config;
    };
  };
}
