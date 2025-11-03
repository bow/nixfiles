{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.nixsys.system;
in
{
  options.nixsys.system = mkOption {
    default = { };
    description = "System settings";
    type = types.submodule {
      options = {
        enable = mkEnableOption "Enable system module";
        linuxPackages = options.boot.kernelPackages // {
          description = "Sets boot.kernelPackages";
          default = pkgs.linuxPackages_latest;
        };
      };
    };
  };

  config = mkIf (cfg.enable || cfg.boot.systemd.enable) {
    boot.kernelPackages = cfg.linuxPackages;
  };
}
