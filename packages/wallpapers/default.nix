{
  pkgs,
  ...
}:
let
  inherit (pkgs.lib) listToAttrs importJSON;
in
listToAttrs (
  builtins.map (wallpaper: {
    inherit (wallpaper) name;
    value = pkgs.fetchurl {
      inherit (wallpaper) sha256;
      name = "${wallpaper.filename}";
      url = "${wallpaper.url}";
    };
  }) (importJSON ./wallpapers.json)
)
