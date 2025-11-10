{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.nixsys.system.nix.nixos-cli;
in
{
  imports = [
    inputs.nixos-cli.nixosModules.nixos-cli
  ];

  options.nixsys.system.nix.nixos-cli = mkOption {
    default = { };
    description = "Settings for nixos-cli tool";
    type = types.submodule {
      options = {
        enable = mkEnableOption "Enable nixos-cli module";
      };
    };
  };

  config = mkIf cfg.enable {
    services.nixos-cli = {
      enable = true;
    };
  };
}
