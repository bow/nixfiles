{
  programs.git = {
    enable = true;
  };

  home.file = {
    ".gitconfig" = {
      source = ../../../dotfiles/gitconfig/.gitconfig;
    };
    ".config/git/ignore" = {
      source = ../../../dotfiles/gitignore/ignore;
    };
  };
}
