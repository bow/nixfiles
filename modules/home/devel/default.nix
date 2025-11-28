{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  inherit (lib) types;
  libcfg = lib.nixsys.home;

  shellBash = libcfg.isShellBash user;

  mkDevelModule =
    {
      name,
      langservers ? [ ],
      tools ? [ ],
      treesitters ? [ ],
      extraOptions ? { },
      extraConfig ? { },
    }:
    let
      inherit (lib) types;
      cfg = config.nixsys.home.devel.${name};
    in
    {
      options.nixsys.home.devel.${name} = lib.mkOption {
        default = { };
        type = types.submodule {
          options = {
            enable = lib.mkEnableOption "nixsys.home.devel.${name}" // {
              default = config.nixsys.home.devel.enable;
            };
            enable-neovim-integration = lib.mkOption {
              default = true;
              type = types.bool;
            };
            langservers = lib.mkOption {
              type = types.listOf types.package;
              default = langservers;
            };
            tools = lib.mkOption {
              type = types.listOf types.package;
              default = tools;
            };
            treesitters = lib.mkOption {
              type = types.listOf types.package;
              default = treesitters;
            };
          }
          // extraOptions;
        };
      };
      config = lib.mkIf cfg.enable (
        {
          home.packages = cfg.tools;
          programs.neovim.extraPackages = lib.mkIf cfg.enable-neovim-integration (
            cfg.langservers ++ cfg.tools ++ cfg.treesitters
          );
        }
        // extraConfig
      );
    };
in
{
  options.nixsys.home.devel = lib.mkOption {
    default = { };
    type = types.submodule {
      freeformType = types.attrsOf types.anything;
      options = {
        enable = lib.mkEnableOption "nixsys.home.devel";
      };
    };
  };

  imports = [

    (mkDevelModule {
      name = "bazel";
      tools = [
        pkgs.unstable.bazel
        pkgs.unstable.starlark-rust
      ];
    })

    (mkDevelModule {
      name = "c";
      langservers = [
        pkgs.unstable.ccls
      ];
      tools = [
        pkgs.unstable.clang_21
        pkgs.unstable.clang-tools
        pkgs.unstable.cmake
        pkgs.unstable.gdb
        pkgs.unstable.gnumake
        pkgs.unstable.valgrind
      ];
      treesitters = [
        pkgs.unstable.tree-sitter-grammars.tree-sitter-c
        pkgs.unstable.tree-sitter-grammars.tree-sitter-cmake
        pkgs.unstable.tree-sitter-grammars.tree-sitter-cpp
      ];
    })

    (mkDevelModule {
      name = "css";
      langservers = [
        pkgs.vscode-langservers-extracted
      ];
      treesitters = [
        pkgs.unstable.tree-sitter-grammars.tree-sitter-css
      ];
    })

    (mkDevelModule {
      name = "go";
      langservers = [
        pkgs.unstable.gopls
      ];
      tools = [
        pkgs.unstable.delve
        pkgs.unstable.go
        pkgs.unstable.gofumpt
      ];
      treesitters = [
        pkgs.unstable.tree-sitter-grammars.tree-sitter-go
        pkgs.unstable.tree-sitter-grammars.tree-sitter-gomod
      ];
      extraConfig = lib.optionalAttrs shellBash {
        programs.bash.bashrcExtra = with config.home; ''
          # Go config.
          export GOPATH="${homeDirectory}/.local/go"
          case ":''${PATH}:" in
              *:"${homeDirectory}/.local/go/bin":*)
                  ;;
              *)
                  export PATH="${homeDirectory}/.local/go/bin:''${PATH}"
                  ;;
          esac
        '';
      };
    })

    (mkDevelModule {
      name = "graphviz";
      langservers = [
        pkgs.unstable.dot-language-server
      ];
      tools = [
        pkgs.graphviz
      ];
      treesitters = [
        pkgs.unstable.tree-sitter-grammars.tree-sitter-dot
      ];
    })

    (mkDevelModule {
      name = "sh";
      langservers = [
        pkgs.unstable.bash-language-server
      ];
      tools = [
        pkgs.unstable.shfmt
      ];
      treesitters = [
        pkgs.unstable.tree-sitter-grammars.tree-sitter-bash
      ];
    })
  ];
}
