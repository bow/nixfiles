{
  pkgs,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "awesome-terminal-fonts";
  version = "1.1.0-25e7d59";
  src = ./awesome-terminal-fonts-25e7d59.tar.gz;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    install -Dm644 fonts/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';
}
