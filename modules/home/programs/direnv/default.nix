{
  config,
  lib,
  user,
  ...
}:
let
  inherit (lib) types;
  libcfg = lib.nixsys.home;

  shellBash = libcfg.isShellBash user;

  cfg = config.nixsys.home.programs.direnv;
in
{
  options.nixsys.home.programs.direnv = lib.mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "nixsys.home.programs.direnv" // {
          default = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = shellBash;
      config = {
        global = {
          warn_timeout = "5m";
          hide_env_diff = false;
        };
      };
      nix-direnv.enable = true;
    };
  };
}
