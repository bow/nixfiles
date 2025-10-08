{
  inputs,
  outputs,
  lib,
  config,
  userName,
  stateVersion,
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
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-pkgs
    ];
  };

  # Reload systemd units on config change.
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
}
