{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.nixsys.home.programs.starship;
in
{
  options.nixsys.home.programs.starship = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.programs.starship" // {
          default = true;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
    };

    home.file = {
      ".config/starship.toml" = {
        source = ../../../../dotfiles/starship/starship.toml;
      };
    };
  };
}
