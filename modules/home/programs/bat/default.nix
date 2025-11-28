{
  config,
  lib,
  pkgs,
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
        package = lib.mkPackageOption pkgs.unstable "bat" { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      inherit (cfg) package;
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };
  };
}
