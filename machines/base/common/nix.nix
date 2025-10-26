{
  lib,
  ...
}:
{
  nix = {
    channel.enable = lib.mkDefault false;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 90d";
    };

    settings = {
      auto-optimise-store = lib.mkDefault true;
      download-buffer-size = lib.mkDefault 134217728; # 128 MiB
      experimental-features = [
        "ca-derivations" # content-addressed derivations.
        "flakes" # nix flakes.
        "nix-command" # new nix subcommands.
      ];
      flake-registry = "";
      max-jobs = "auto";
      min-free = lib.mkDefault 1073741824; # 1 GiB
      trusted-users = lib.mkDefault [
        "root"
        "@wheel"
      ];
    };
  };
}
