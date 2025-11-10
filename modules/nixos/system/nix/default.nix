{
  config,
  lib,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.nixsys.system.nix;
in
{
  options.nixsys.system.nix = mkOption {
    default = { };
    description = "Nix settings";
    type = types.submodule {
      options = {
        downloadBufferSize = mkOption {
          type = types.ints.positive;
          default = 134217728; # 128 MiB
          description = "Sets nix.settings.download-buffer-size";
        };
        gcMaxRetentionDays = mkOption {
          type = types.ints.positive;
          default = 30;
          description = "The age of the oldest item to keep (in days) after garbage collection";
        };
        gcMinFreeSpace = mkOption {
          type = types.ints.positive;
          default = 1073741824; # 1 GiB
          description = "Sets nix.settings.min-free";
        };
      };
    };
  };

  config = {
    environment.etc."nix/path/nixpkgs".source = inputs.nixpkgs;

    nix = {
      channel.enable = false;
      nixPath = [ "/etc/nix/path" ];
      registry.nixpkgs.flake = inputs.nixpkgs;

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than ${builtins.toString cfg.gcMaxRetentionDays}";
      };

      settings = {
        auto-optimise-store = true;
        download-buffer-size = cfg.downloadBufferSize;
        experimental-features = [
          "ca-derivations" # content-addressed derivations.
          "flakes" # nix flakes.
          "nix-command" # new nix subcommands.
        ];
        max-jobs = "auto";
        min-free = cfg.gcMinFreeSpace;
        trusted-users = [ "root" ];
      };
    };

    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
      config.allowUnfree = true;
    };

    programs.nix-ld = {
      enable = true;
    };
  };
}
