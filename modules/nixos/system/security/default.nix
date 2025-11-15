{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
in
{
  options.nixsys.system.security = mkOption {
    type = types.submodule {
      options = {
      };
    };
  };

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
