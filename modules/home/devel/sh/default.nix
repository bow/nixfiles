{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  develCfg = config.nixsys.home.devel;

  cfg = config.nixsys.home.devel.sh;
in
{
  options.nixsys.home.devel.sh = lib.mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "nixsys.home.devel.sh" // {
          default = develCfg.enable;
        };
        enable-neovim-integration = lib.mkOption {
          default = true;
          type = types.bool;
        };
        langservers = lib.mkOption {
          type = types.listOf types.package;
          default = [
            pkgs.unstable.bash-language-server
          ];
        };
        tools = lib.mkOption {
          type = types.listOf types.package;
          default = [
            pkgs.unstable.shfmt
          ];
        };
        treesitters = lib.mkOption {
          type = types.listOf types.package;
          default = [
            pkgs.unstable.tree-sitter-grammars.tree-sitter-bash
          ];
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = cfg.tools;
    programs.neovim.extraPackages = lib.mkIf cfg.enable-neovim-integration (
      cfg.langservers ++ cfg.tools ++ cfg.treesitters
    );
  };
}
