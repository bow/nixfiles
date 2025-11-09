{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.nixsys.system;
in
{
  # Default external modules.
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.nixsys.system = mkOption {
    default = { };
    description = "System settings";
    type = types.submodule {
      options = {
        enable = mkEnableOption "Enable system module";
      };
    };
  };

  config = mkIf (cfg.enable) {

    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v20n.psf.gz";
      keyMap = "us";
      packages = [ pkgs.terminus_font ];
    };

    environment = {
      systemPackages = with pkgs; [
        curl
        findutils
        file
        fzf
        gcc
        gdb
        git
        gnugrep
        gnumake
        gnupg
        gnused
        home-manager
        jq
        neovim
        readline
        ripgrep
        unzip
        vim
        wget
      ];
      variables = {
        EDITOR = "nvim";
      };
    };

    i18n.defaultLocale = "en_US.UTF-8";

    time.timeZone = "Europe/Copenhagen";
  };
}
