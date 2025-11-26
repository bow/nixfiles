{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkPackageOption
    types
    ;
  inherit (lib.nixsys.home) isNeovimEnabled isShellBash;

  neovimEnabled = isNeovimEnabled config;
  shellBash = isShellBash user;

  cfg = config.nixsys.home.programs.fzf;
in
{
  options.nixsys.home.programs.fzf = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.programs.fzf" // {
          default = true;
        };
        package = mkPackageOption pkgs.unstable "fzf" { };
      };
    };
  };

  config = mkIf cfg.enable {

    programs.fzf = {
      enable = true;
      inherit (cfg) package;
      enableBashIntegration = shellBash;

      colors = {
        "fg" = "#ebdbb2";
        "bg" = "#282828";
        "hl" = "#fabd2f";
        "fg+" = "#ebdbb2";
        "bg+" = "#3c3836";
        "hl+" = "#fabd2f";
        "info" = "#83a598";
        "prompt" = "#bdae93";
        "spinner" = "#fabd2f";
        "pointer" = "#83a598";
        "marker" = "#fe8019";
        "header" = "#665c54";
      };
    };

    programs.neovim.extraPackages = mkIf neovimEnabled [ cfg.package ];
  };
}
