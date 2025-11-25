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
    security = {
      sudo = {
        enable = true;
        wheelNeedsPassword = false;
        execWheelOnly = true;
        keepTerminfo = true;
      };
    };
  };
}
