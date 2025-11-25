{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.nixsys.nixos) hasProfileWorkstation;

  profileWorkstation = hasProfileWorkstation config;
in
{
  config = mkIf config.nixsys.enable {
    environment = {
      pathsToLink = [ "/share/bash-completion" ];
      systemPackages =
        with pkgs;
        [
          curl
          findutils
          file
          fzf
          git
          gnugrep
          gnupg
          gnused
          iputils
          jq
          neovim
          readline
          ripgrep
          unzip
          vim
          wget
        ]
        ++ (lib.optionals profileWorkstation [ pkgs.home-manager ]);
      variables = {
        EDITOR = "nvim";
      };
    };
  };
}
