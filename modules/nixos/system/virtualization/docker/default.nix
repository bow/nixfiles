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
  inherit (lib.nixsys.nixos) getMainUser isMainUserDefined;

  mainUser = getMainUser config;
  mainUserDefined = isMainUserDefined config;

  cfg = config.nixsys.system.virtualization.docker;
in
{
  options.nixsys.system.virtualization.docker = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.system.virtualization.docker";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users = mkIf (mainUser != null) {
      ${mainUser.name}.extraGroups = [ "docker" ];
    };

    virtualisation = {
      oci-containers.backend = "docker";
      docker = {
        enable = true;
        autoPrune = {
          enable = true;
          persistent = true;
          dates = "daily";
          flags = [
            "--force"
            "--all"
            "--volumes"
          ];
        };
      };
    };
  };
}
