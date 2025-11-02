{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  inherit (lib.nixsys) mkOpt;

  cfg = config.nixsys.system.boot.systemd;
in
{
  options.nixsys.system.boot.systemd = mkOption {
    default = { };
    description = "Boot settings for systemd-boot";
    type = types.submodule {
      options = {
        enable = mkEnableOption "Enable boot module";
        loaderTimeout = mkOpt (types.nullOr types.int) 1 "Sets boot.loader.timeout";
        consoleMode = mkOpt types.str "auto" "Sets boot.loader.systemd-boot.consoleMode";
      };
    };
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        timeout = cfg.loaderTimeout;
        systemd-boot = {
          enable = true;
          consoleMode = cfg.consoleMode;
        };
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
    };
  };
}
