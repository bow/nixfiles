{
  config,
  lib,
  pkgs,
  ...
}:
let
  libcfg = lib.nixsys.nixos;

  profileWorkstation = libcfg.isProfileWorkstation config;
in
{
  config = lib.mkIf config.nixsys.enable {
    environment = {
      pathsToLink = [ "/share/bash-completion" ];
      systemPackages = [
        pkgs.curl
        pkgs.findutils
        pkgs.file
        pkgs.git
        pkgs.gnugrep
        pkgs.gnupg
        pkgs.gnused
        pkgs.iputils
        pkgs.jq
        pkgs.neovim
        pkgs.readline
        pkgs.unzip
        pkgs.vim
        pkgs.wget

        pkgs.unstable.ripgrep
      ]
      ++ (lib.optionals profileWorkstation [ pkgs.home-manager ]);
      variables = {
        EDITOR = "nvim";
      };
    };
  };
}
