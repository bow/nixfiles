{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.nixsys.nixos) isProfileWorkstation;

  profileWorkstation = isProfileWorkstation config;
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
