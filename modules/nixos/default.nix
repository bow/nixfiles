{
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;
in
{
  # Default external modules.
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.nixsys = mkOption {
    default = { };
    description = "nixsys settings";
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys";
      };
    };
  };
}
