{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.nixsys.nixos) hasProfileWorkstation;
in
{
  config = mkIf (hasProfileWorkstation config) {
    services.upower.enable = true;
  };
}
