{
  pkgs,
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "titillium-fonts";
  version = "2.0.1";
  src = ./Titillium_roman_upright_italic_2_0_OT.zip;

  unpackPhase = ''
    runHook preUnpack

    ${pkgs.unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    install -Dm644 Titillium_roman_upright_italic_2_0_OT/*.otf $out/share/fonts/truetype

    runHook postInstall
  '';
}
