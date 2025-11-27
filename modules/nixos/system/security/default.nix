{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.nixsys.enable {
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
