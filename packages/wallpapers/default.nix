{
  pkgs,
  ...
}:
let
  inherit (pkgs.lib) listToAttrs importJSON;

  mkWallpaperPkg = wallpaper: {
    inherit (wallpaper) name;
    value = pkgs.stdenvNoCC.mkDerivation {
      pname = "${wallpaper.name}";
      version = "0.0.0";

      src = pkgs.fetchurl {
        inherit (wallpaper) sha256;
        name = "${wallpaper.filename}";
        url = "${wallpaper.url}";
      };

      unpackPhase = "true";

      buildPhase = ''
        mkdir -p $out
        cp $src $out/image
        ${pkgs.imagemagick}/bin/magick $src -blur 0x8 $out/image-blurred
      '';
    };
  };
in
listToAttrs (builtins.map (mkWallpaperPkg) (importJSON ./wallpapers.json))
