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
      systemPackages =
        with pkgs;
        [
          curl
          findutils
          file
          git
          gnugrep
          gnupg
          gnused
          iputils
          jq
          neovim
          readline
          unzip
          vim
          wget

          unstable.ripgrep
        ]
        ++ (lib.optionals profileWorkstation [ pkgs.home-manager ]);
      variables = {
        EDITOR = "nvim";
      };
    };
  };
}
