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

  cfg = config.nixsys.home.programs.readline;
in
{
  options.nixsys.home.programs.readline = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.programs.readline" // {
          default = true;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.readline = {
      enable = true;
    };

    home.file = {
      ".inputrc" = {
        source = ../../../../dotfiles/readline/.inputrc;
      };
    };
  };
}
