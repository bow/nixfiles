{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.nixsys.home.programs.ghostty;
in
{
  options.nixsys.home.programs.ghostty = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.programs.graphical.ghostty" // {
          default = true;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.ghostty ];

    home.file = {
      ".config/ghostty/config" = {
        source = ../../../../dotfiles/ghostty/config;
      };
    };
  };
}
