{
  inputs,
  outputs,
  ...
}:
{
  imports = [
    ./keyd.nix
    ./nix.nix
    ./nix-ld.nix
    ./nixos-cli.nix
  ];
}
