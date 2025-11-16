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

  cfg = config.nixsys.home.programs.git;
in
{
  options.nixsys.home.programs.git = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.programs.git" // {
          default = true;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
    };

    home.file = {
      ".gitconfig" = {
        source = ../../../../dotfiles/gitconfig/.gitconfig;
      };
      ".config/git/ignore" = {
        source = ../../../../dotfiles/gitignore/ignore;
      };
    };
  };
}
