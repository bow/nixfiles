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
      bindings = {
        "\\e[A" = "history-search-backward";
        "\\e[B" = "history-search-forward";
      };
      variables = {
        colored-completion-prefix = true;
        colored-stats = true;
        comment-begin = "# ";
        mark-symlinked-directories = true;
        show-all-if-unmodified = true;
        skip-completed-text = true;
      };
      extraConfig = ''
        set bell-style none
      '';
    };
  };
}
