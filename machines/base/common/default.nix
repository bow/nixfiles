{
  outputs,
  ...
}:
{
  imports = [
    ./services-keyd.nix
    ./services-nixos-cli.nix

    outputs.nixosModules.default
  ];
}
