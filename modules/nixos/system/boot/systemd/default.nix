{
  config,
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixsys) mkOpt;

  cfg = config.nixsys.system.boot.systemd;
in
{
  options.nixsys.system.boot.systemd = {
    enable = lib.mkEnableOption "Enable boot module";

    console-mode = lib.mkOption {
      description = "Sets boot.loader.systemd-boot.consoleMode";
      type = types.str;
      default = "auto";
    };

    loader-timeout = lib.mkOption {
      description = "Sets boot.loader.timeout";
      type = types.nullOr types.ints.positive;
      default = 1;
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      loader = {
        timeout = cfg.loader-timeout;
        systemd-boot = {
          enable = true;
          consoleMode = cfg.console-mode;
        };
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
    };
  };
}
