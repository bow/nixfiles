{
  config,
  lib,
  ...
}:
let
  libcfg = lib.nixsys.nixos;

  xorgEnabled = libcfg.isXorgEnabled config;

  cfg = config.nixsys.system.hardware.touchpad;
in
{
  options.nixsys.system.hardware.touchpad = {
    enable = lib.mkEnableOption "nixsys.system.hardware.touchpad";
  };

  config = lib.mkIf (cfg.enable && xorgEnabled) {
    services.libinput = {
      enable = true;
      touchpad = {
        accelProfile = "adaptive";
        accelSpeed = "0.65";
        clickMethod = "clickfinger";
        horizontalScrolling = false;
        naturalScrolling = true;
        scrollMethod = "twofinger";
        tapping = true;
        tappingButtonMap = "lmr";
        additionalOptions = ''
          Option "TappingDrag" "on"
        '';
      };
    };
  };
}
