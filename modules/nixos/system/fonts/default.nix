{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.nixsys.enable {
    fonts.enableDefaultPackages = true;
  };
}
