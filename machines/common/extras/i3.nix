{
  pkgs,
  ...
}:
{
  environment.pathsToLink = [ "/libexec" ];

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        rofi-pass
        polybar
      ];
    };
  };

  services.displayManager = {
    defaultSession = "none+i3";
  };

  programs.i3lock.enable = true;

  security.pam.services = {
    i3lock-color.enable = true;
  };
}
