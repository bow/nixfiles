{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.nixsys.system.nix.nixos-cli;
in
{
  imports = [
    inputs.nixos-cli.nixosModules.nixos-cli
  ];

  options.nixsys.system.nix.nixos-cli = lib.mkOption {
    default = { };
    description = "Settings for nixos-cli tool";
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "Enable nixos-cli module";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nixos-cli = {
      enable = true;
    };
  };
}
