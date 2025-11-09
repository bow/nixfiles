{
  lib,
  pkgs,
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
    default = { };
    description = "System settings";
    type = types.submodule {
      options = {
        kind = mkOption { type = types.enum ["workstation" "node"]; };
      };
    };
  };

  config = {

    i18n.defaultLocale = "en_US.UTF-8";

    time.timeZone = "Europe/Copenhagen";
  };
}
