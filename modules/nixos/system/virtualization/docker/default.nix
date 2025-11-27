{
  config,
  lib,
  ...
}:
let
  inherit (lib) types;
  libcfg = lib.nixsys.nixos;

  mainUser = libcfg.getMainUser config;
  mainUserDefined = libcfg.isMainUserDefined config;

  cfg = config.nixsys.system.virtualization.docker;
in
{
  options.nixsys.system.virtualization.docker = lib.mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "nixsys.system.virtualization.docker";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf mainUserDefined {
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
