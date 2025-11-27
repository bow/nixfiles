{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  develCfg = config.nixsys.home.devel;

  cfg = config.nixsys.home.devel.c;
in
{
  options.nixsys.home.devel.c = lib.mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "nixsys.home.devel.c" // {
          default = develCfg.enable;
        };
        enable-neovim-integration = lib.mkOption {
          default = true;
          type = types.bool;
        };
        langservers = lib.mkOption {
          type = types.listOf types.package;
          default = [ pkgs.unstable.ccls ];
        };
        tools = lib.mkOption {
          type = types.listOf types.package;
          default = [
            pkgs.unstable.clang_21
            pkgs.unstable.clang-tools
            pkgs.unstable.cmake
            pkgs.unstable.gdb
            pkgs.unstable.gnumake
            pkgs.unstable.valgrind
          ];
        };
        treesitters = lib.mkOption {
          type = types.listOf types.package;
          default = with pkgs.unstable.tree-sitter-grammars; [
            tree-sitter-c
            tree-sitter-cmake
            tree-sitter-cpp
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
