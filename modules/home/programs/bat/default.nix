{
  config,
  lib,
  ...
}:
let
  inherit (lib) types;

  cfg = config.nixsys.home.programs.bat;
in
{
  options.nixsys.home.programs.bat = lib.mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "nixsys.home.programs.bat" // {
          default = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };
  };
}
