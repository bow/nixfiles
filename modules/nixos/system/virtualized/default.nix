{
  config,
  lib,
  ...
}:
let
  inherit (lib) types;
  libcfg = lib.nixsys.nixos;

  xorgEnabled = libcfg.isXorgEnabled config;

  cfg = config.nixsys.system.virtualized;
in
{
  options.nixsys.system.virtualized = lib.mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "nixsys.system.virtualized";
        guest-type = lib.mkOption {
          type = types.enum [ "qemu" ];
          description = "The type of the guest agent to run";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.qemuGuest.enable = cfg.guest-type == "qemu";
    services.spice-vdagentd.enable = xorgEnabled;
  };
}
