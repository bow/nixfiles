{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (lib.nixsys.nixos) isXorgEnabled;

  cfg = config.nixsys.system.virtualized;
in
{
  options.nixsys.system.virtualized = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.system.virtualized";
        guest-type = mkOption {
          type = types.enum [ "qemu" ];
          description = "The type of the guest agent to run";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.qemuGuest.enable = cfg.guest-type == "qemu";
    services.spice-vdagentd.enable = (isXorgEnabled config);
  };
}
