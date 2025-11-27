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

  cfg = config.nixsys.home.programs.zoxide;
in
{
  options.nixsys.home.programs.zoxide = lib.mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "nixsys.home.programs.zoxide" // {
          default = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = shellBash;
      options = [ "--cmd j" ];
    };
  };
}
