{
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./console.nix
    ./environment.nix
    ./localization.nix
    ./nix.nix
    ./nixpkgs.nix
    ./programs-nix-ld.nix
    ./services-keyd.nix
    ./services-nixos-cli.nix
  ];
}
