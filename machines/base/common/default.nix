{
  outputs,
  ...
}:
{
  imports = [
    ./services-keyd.nix

    outputs.nixosModules.default
  ];
}
