{
  lib,
  user,
  ...
}:
let
  inherit (lib) mkForce mkIf;
in
{
  config = mkIf (user.shell == "bash") {

    programs.bash.enable = true;

    home.file = {
      ".bashrc" = {
        source = mkForce ../../../../dotfiles/bash/.bashrc;
      };
    };
  };
}
