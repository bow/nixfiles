{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.nixsys.enable {
    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v20n.psf.gz";
      keyMap = "us";
      packages = [ pkgs.terminus_font ];
    };
  };
}
