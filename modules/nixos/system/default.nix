{
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  # Default external modules.
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

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
      };
    };
  };
}
