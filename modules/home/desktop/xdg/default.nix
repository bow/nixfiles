{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.nixsys.home.desktop.xdg;
in
{
  options.nixsys.home.desktop.xdg = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.desktop.xdg" // {
          default = true;
        };
        create-directories = mkOption {
          default = true;
          type = types.bool;
          description = "Sets xdg.userDirs.createDirectories";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.userDirs = with config.home; {
      enable = true;
      createDirectories = cfg.create-directories;
      desktop = "${homeDirectory}/dsk";
      download = "${homeDirectory}/dl";
      templates = "${homeDirectory}/.xdg-templates";
      publicShare = "${homeDirectory}/.xdg-public";
      documents = "${homeDirectory}/docs";
      music = "${homeDirectory}/music";
      pictures = "${homeDirectory}/pics";
      videos = "${homeDirectory}/vids";
    };
  };
}
