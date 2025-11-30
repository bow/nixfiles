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

  options.nixsys.system = {
    hostname = lib.mkOption { type = types.str; };
    profile = lib.mkOption {
      type = types.enum [
        "workstation"
        "node"
      ];
    };
  };
}
