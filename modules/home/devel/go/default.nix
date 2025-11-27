{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  develCfg = config.nixsys.home.devel;

  cfg = config.nixsys.home.devel.go;
in
{
  options.nixsys.home.devel.go = lib.mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "nixsys.home.devel.go" // {
          default = develCfg.enable;
        };
        enable-neovim-integration = lib.mkOption {
          default = true;
          type = types.bool;
        };
        langservers = lib.mkOption {
          type = types.listOf types.package;
          default = [
            pkgs.unstable.gopls
          ];
        };
        tools = lib.mkOption {
          type = types.listOf types.package;
          default = [
            pkgs.unstable.delve
            pkgs.unstable.go
            pkgs.unstable.gofumpt
          ];
        };
        treesitters = lib.mkOption {
          type = types.listOf types.package;
          default = [
            pkgs.unstable.tree-sitter-grammars.tree-sitter-go
            pkgs.unstable.tree-sitter-grammars.tree-sitter-gomod
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
