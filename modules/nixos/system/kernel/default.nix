{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  cfg = config.nixsys.system.kernel;
in
{
  options.nixsys.system.kernel = {
    package = options.boot.kernelPackages // {
      description = "Sets the system kernel";
      default = pkgs.linuxPackages_latest;
    };
  };

  config = lib.mkIf config.nixsys.enable {
    boot.kernelPackages = cfg.package;
  };
}
