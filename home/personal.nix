{
  inputs,
  outputs,
  lib,
  config,
  userName,
  asStandalone ? true,
  ...
}:

{
  home.stateVersion = "25.05";

  imports = [
    suites/console
    suites/graphical
  ];

  home = {
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
