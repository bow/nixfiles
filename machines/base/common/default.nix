{
  outputs,
  ...
}:
{
  imports = [
    ./environment.nix
    ./localization.nix
    ./nix.nix
    ./nixpkgs.nix
    ./programs-nix-ld.nix
    ./services-keyd.nix
    ./services-nixos-cli.nix

    outputs.nixosModules.default
  ];
}
