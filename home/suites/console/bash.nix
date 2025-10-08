{
  pkgs,
  ...
}:
{
  programs.bash = {
    enable = true;
  };
  home.file = {
    ".bashrc" = {
      # TODO: Split this to be more Nix-friendly.
      source = pkgs.lib.mkForce ../../../dotfiles/bash/.bashrc;
    };
  };
}
