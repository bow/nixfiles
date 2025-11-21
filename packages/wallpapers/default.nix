{
  pkgs,
  ...
}:
let
  inherit (pkgs.lib) listToAttrs;

  mkWallpaperPkg = wallpaper: {
    inherit (wallpaper) name;
    value = pkgs.stdenvNoCC.mkDerivation {
      pname = "${wallpaper.name}";
      version = "0.0.0";

      src = pkgs.fetchurl {
        inherit (wallpaper) sha256;
        name = "${wallpaper.name}.${wallpaper.ext}";
        url = "${wallpaper.url}";
      };

      unpackPhase = "true";

      buildPhase = ''
        mkdir -p $out
        cp $src $out/desktop-bg
        ${pkgs.imagemagick}/bin/magick $src -blur 0x8 $out/lock-screen-bg
      '';
    };
  };
in
listToAttrs (
  builtins.map (mkWallpaperPkg) [
    {
      name = "francesco-ungaro-lcQzCo-X1vM-unsplash";
      ext = "jpg";
      url = "https://images.unsplash.com/photo-1729839472414-4f28edcb5b80?ixlib=rb-4.1.0&q=85&fm=jpg&crop=entropy&cs=srgb&dl=francesco-ungaro-lcQzCo-X1vM-unsplash.jpg&w=2400";
      sha256 = "b7c5b4377c96ff99f618fb04ea78070851db94e14d62cf6464a1b27fddad25a8";
    }
  ]
)
