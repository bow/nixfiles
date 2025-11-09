{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
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
        ++ (lib.optionals (config.nixsys.system.kind == "workstation") [ pkgs.home-manager ]);
      variables = {
        EDITOR = "nvim";
      };
    };
  };
}
