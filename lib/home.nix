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
    Return whether the current config enables docker.
  */
  isDockerEnabled =
    config:
    let
      sys = config.nixsys.home.system;
    in
    sys != { } && sys.docker.enable;

  /**
    Return whether the current config enables the given program.
  */
  isProgramEnabled = config: name: config.nixsys.home.programs.${name}.enable;

  /**
    Return whether the current config enables neovim.
  */
  isNeovimEnabled = config: isProgramEnabled config "neovim";

  /**
    Return whether the current config enables zoxide.
  */
  isZoxideEnabled = config: isProgramEnabled config "zoxide";

  /**
    Return whether the current user enables a bash shell.
  */
  usesBash = user: user.shell == "bash";
}
