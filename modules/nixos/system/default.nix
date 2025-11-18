{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  imports = [ ./workstation.nix ];

  options.nixsys.system = mkOption {
    description = "System settings";
    type = types.submodule {
      options = {
        profile = mkOption {
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
