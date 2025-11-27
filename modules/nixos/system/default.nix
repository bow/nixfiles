{
  lib,
  ...
}:
let
  inherit (lib) types;
in
{
  imports = [
    ./workstation.nix
  ];

  options.nixsys.system = lib.mkOption {
    default = { };
    description = "System settings";
    type = types.submodule {
      options = {
        hostname = lib.mkOption { type = types.str; };
        profile = lib.mkOption {
          type = types.enum [
            "workstation"
            "node"
          ];
        };
      };
    };
  };
}
