{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  programs.neovim = {
    enable = true;
    viAlias = false;
    vimAlias = false;
    vimdiffAlias = true;
    plugins = with pkgs-unstable; [
      vimPlugins.nvim-treesitter.withAllGrammars
      vimPlugins.nvim-treesitter
    ];
    extraPackages = with pkgs-unstable; [
      # Shared
      fzf
      ripgrep
      tree-sitter
      lua54Packages.jsregexp

      # Bash
      bash-language-server
      tree-sitter-grammars.tree-sitter-bash

      # Bazel
      starlark-rust

      # C/C++
      ccls
      tree-sitter-grammars.tree-sitter-c
      tree-sitter-grammars.tree-sitter-cmake
      tree-sitter-grammars.tree-sitter-cpp

      # CSS
      vscode-langservers-extracted
      tree-sitter-grammars.tree-sitter-css

      # Dot
      tree-sitter-grammars.tree-sitter-dot

      # Elixir / Erlang
      tree-sitter-grammars.tree-sitter-elixir
      tree-sitter-grammars.tree-sitter-erlang

      # Go
      delve
      go
      gofumpt
      gopls
      tree-sitter-grammars.tree-sitter-go
      tree-sitter-grammars.tree-sitter-gomod

      # Haskell
      haskell-language-server
      tree-sitter-grammars.tree-sitter-haskell

      # HCL / Terraform
      terraform-ls
      terraform-lsp
      tree-sitter-grammars.tree-sitter-hcl

      # HTML
      tree-sitter-grammars.tree-sitter-html

      # HTTP
      tree-sitter-grammars.tree-sitter-http

      # Java
      jdt-language-server
      tree-sitter-grammars.tree-sitter-java

      # JavaScript / TypeScript
      nodejs_24
      tree-sitter-grammars.tree-sitter-javascript
      tree-sitter-grammars.tree-sitter-jsdoc
      tree-sitter-grammars.tree-sitter-typescript

      # JSON
      tree-sitter-grammars.tree-sitter-json

      # Justfile
      tree-sitter-grammars.tree-sitter-just

      # Kotlin
      tree-sitter-grammars.tree-sitter-kotlin

      # Lua
      lua-language-server
      luajitPackages.jsregexp
      stylua
      tree-sitter-grammars.tree-sitter-lua

      # Make
      tree-sitter-grammars.tree-sitter-make

      # Markdown
      tree-sitter-grammars.tree-sitter-markdown
      tree-sitter-grammars.tree-sitter-markdown-inline

      # Latex
      texlab
      tree-sitter-grammars.tree-sitter-bibtex
      tree-sitter-grammars.tree-sitter-latex

      # Nix
      deadnix
      nil
      nixfmt-rfc-style
      statix
      tree-sitter-grammars.tree-sitter-nix

      # Perl
      perlnavigator
      tree-sitter-grammars.tree-sitter-perl

      # PHP
      tree-sitter-grammars.tree-sitter-php

      # Protobuf
      buf
      tree-sitter-grammars.tree-sitter-proto

      # Python
      basedpyright
      mypy
      pyrefly
      python313Packages.python-lsp-server
      ruff
      tree-sitter-grammars.tree-sitter-python

      # Regex
      tree-sitter-grammars.tree-sitter-regex

      # Rust
      cargo
      rustc
      tree-sitter-grammars.tree-sitter-rust

      # Ruby
      ruby-lsp
      tree-sitter-grammars.tree-sitter-ruby

      # Scala
      tree-sitter-grammars.tree-sitter-scala

      # SQL
      postgres-lsp
      tree-sitter-grammars.tree-sitter-sql

      # TOML
      tree-sitter-grammars.tree-sitter-toml

      # YAML
      tree-sitter-grammars.tree-sitter-yaml
    ];
  };

  home.file = {
    ".config/nvim" = {
      source = ../../../dotfiles/nvim;
      recursive = true;
    };
  };
}
