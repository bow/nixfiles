{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.nixsys.system = mkOption {
    description = "System settings";
    type = types.submodule {
      options = {
        kind = mkOption {
          type = types.enum [
            "workstation"
            "node"
          ];
        };
        hostname = mkOption { type = types.str; };
      };
    };
  };
}
