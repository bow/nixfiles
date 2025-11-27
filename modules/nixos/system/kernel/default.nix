{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  inherit (lib) types;

  cfg = config.nixsys.system.kernel;
in
{
  options.nixsys.system.kernel = lib.mkOption {
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

  config = lib.mkIf config.nixsys.enable {
    boot.kernelPackages = cfg.package;
  };
}
