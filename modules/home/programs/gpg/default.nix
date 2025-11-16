{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  inherit (lib.nixsys) mkOpt;
  inherit (lib.nixsys.home) isXorgEnabled;

  cfg = config.nixsys.home.programs.gpg;
in
{
  options.nixsys.home.programs.gpg = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.home.programs.gpg" // {
          default = true;
        };

        default-cache-ttl =
          mkOpt (types.nullOr types.ints.positive) 86400
            "Sets services.gpg-agent.defaultCacheTtl";

        default-cache-ttl-ssh =
          mkOpt (types.nullOr types.ints.positive) 86400
            "Sets services.gpg-agent.defaultCacheTtlSsh";

        exported-as-ssh = mkOpt (types.nullOr (
          types.listOf types.str
        )) null "Sets services.gpg-agent.sshKeys";

        max-cache-ttl = mkOpt (types.nullOr types.ints.positive) (
          14 * 86400
        ) "Sets services.gpg-agent.defaultCacheTtl";

        max-cache-ttl-ssh = mkOpt (types.nullOr types.ints.positive) (
          7 * 86400
        ) "Sets services.gpg-agent.defaultCacheTtlSsh";

        mutable-keys = mkOpt types.bool true "Sets programs.gpg.mutableKeys";

        mutable-trust = mkOpt types.bool true "Sets programs.gpg.mutableTrust";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      mutableKeys = cfg.mutable-keys;
      mutableTrust = cfg.mutable-trust;
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = cfg.default-cache-ttl;
      defaultCacheTtlSsh = cfg.default-cache-ttl-ssh;
      enableBashIntegration = true;
      enableSshSupport = true;
      maxCacheTtl = cfg.max-cache-ttl;
      maxCacheTtlSsh = cfg.max-cache-ttl-ssh;
      pinentry.package = if (isXorgEnabled config) then pkgs.pinentry-gtk2 else pkgs.pinentry-tty;
      sshKeys = cfg.exported-as-ssh;
    };
  };
}
