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

  /**
    Return whether the current config enables the given program.
  */
  isProgramEnabled = config: name: config.nixsys.home.programs.${name}.enable;

  /**
    Return whether the current config enables neovim.
  */
  isNeovimEnabled = config: isProgramEnabled config "neovim";
}
