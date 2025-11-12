{
  user,
  lib,
  outputs,
  asStandalone,
  ...
}:
{
  imports = [
    ../../../../../home/suites/console
    ../../../../../home/suites/graphical
  ];

  config = {
    home = {
      stateVersion = "25.05";
      username = user.name;
      homeDirectory = user.home-directory;
    };

    nixpkgs = lib.mkIf asStandalone {
      overlays = builtins.attrValues outputs.overlays;
      config.allowUnfree = true;
    };

    # Reload systemd units on config change.
    systemd.user.startServices = "sd-switch";

    programs.home-manager.enable = true;
  };
}
