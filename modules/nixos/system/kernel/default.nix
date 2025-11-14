{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.nixsys.system.kernel;
in
{
  options.nixsys.system.kernel = mkOption {
    default = { };
    description = "System kernel";
    type = types.submodule {
      options = {
        package = options.boot.kernelPackages // {
          description = "Sets the system kernel";
          default = pkgs.linuxPackages_latest;
        };
      };
    };
  };

  config = {
    boot.kernelPackages = cfg.package;
  };
}
