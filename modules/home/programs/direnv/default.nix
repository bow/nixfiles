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
      nix-direnv.enable = true;
    };

    home.file = {
      ".config/direnv" = {
        source = ../../../../dotfiles/direnv;
        recursive = true;
      };
    };
  };
}
