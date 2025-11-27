{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  develCfg = config.nixsys.home.devel;

  cfg = config.nixsys.home.devel.bazel;
in
{
  options.nixsys.home.devel.bazel = lib.mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "nixsys.home.devel.bazel" // {
          default = develCfg.enable;
        };
        enable-neovim-integration = lib.mkOption {
          default = true;
          type = types.bool;
        };
        langservers = lib.mkOption {
          type = types.listOf types.package;
          default = [ ];
        };
        tools = lib.mkOption {
          type = types.listOf types.package;
          default = [
            pkgs.unstable.bazel
            pkgs.unstable.starlark-rust
          ];
        };
        treesitters = lib.mkOption {
          type = types.listOf types.package;
          default = [ ];
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
