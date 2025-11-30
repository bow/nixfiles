{
  lib,
  inputs,
  ...
}:
{
  # Default external modules.
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.nixsys = {
    enable = lib.mkEnableOption "nixsys";
  };
}
