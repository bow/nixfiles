{
  pkgs,
  ...
}:
{
  config = {
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
  };
}
