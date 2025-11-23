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

  cfg = config.nixsys.home.programs.zoxide;
in
{
  options.nixsys.home.programs.zoxide = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.programs.zoxide" // {
          default = true;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = usesBash user;
      options = [ "--cmd j" ];
    };
  };
}
