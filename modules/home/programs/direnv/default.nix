{
  config,
  lib,
  user,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  inherit (lib.nixsys.home) usesBash;

  cfg = config.nixsys.home.programs.direnv;
in
{
  options.nixsys.home.programs.direnv = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.programs.direnv" // {
          default = true;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = usesBash user;
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
