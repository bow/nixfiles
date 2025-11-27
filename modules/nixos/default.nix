{
  lib,
  inputs,
  ...
}:
let
  inherit (lib) types;
in
{
  # Default external modules.
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.nixsys = lib.mkOption {
    default = { };
    description = "nixsys settings";
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "nixsys";
      };
    };
  };
}
