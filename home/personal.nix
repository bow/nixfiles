{
  inputs,
  outputs,
  lib,
  config,
  userName,
  stateVersion,
  asStandalone ? true,
  ...
}:

{
  imports = [
    suites/console
    suites/graphical
  ];

  home = {
    stateVersion = stateVersion;
    username = userName;
    homeDirectory = "/home/${userName}";
  };

  nixpkgs = lib.mkIf asStandalone {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  # Reload systemd units on config change.
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
}
