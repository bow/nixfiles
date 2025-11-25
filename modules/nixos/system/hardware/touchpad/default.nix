{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  inherit (lib.nixsys.nixos) isXorgEnabled;

  xorgEnabled = isXorgEnabled config;

  cfg = config.nixsys.system.hardware.touchpad;
in
{
  options.nixsys.system.hardware.touchpad = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.system.hardware.touchpad";
      };
    };
  };

  config = mkIf (cfg.enable && xorgEnabled) {
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
