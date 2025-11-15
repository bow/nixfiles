{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.nixsys.enable {
    environment = {
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
        ++ (lib.optionals (config.nixsys.system.profile == "workstation") [ pkgs.home-manager ]);
      variables = {
        EDITOR = "nvim";
      };
    };
  };
}
