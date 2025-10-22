{
  pkgs,
  ...
}:
{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = rec {
      modifier = "Mod4";
      keybindings = {
        "${modifier}+Return" = "exec ${pkgs.ghostty}";
      };
    };
  };
}
