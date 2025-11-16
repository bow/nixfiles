{
  ...
}:
rec {
  /**
    Return whether the current config enables Xorg.
  */
  isXorgEnabled = config: config.nixsys.home.desktop.i3.enable;

  /**
    Return whether the current config enables desktop.
  */
  isDesktopEnabled = config: isXorgEnabled config;
}
