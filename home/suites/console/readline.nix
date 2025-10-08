{
  programs.readline = {
    enable = true;
  };
  home.file = {
    ".inputrc" = {
      source = ../../../dotfiles/readline/.inputrc;
    };
  };
}
