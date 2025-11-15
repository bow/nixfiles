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
  inherit (lib.nixsys.cfg) isXorgEnabled;

  cfg = config.nixsys.users.programs.gnupg;
in
{
  options.nixsys.users.programs.gnupg = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.users.programs.gnupg";
        agent-settings = mkOption rec {
          type = types.attrs;
          default = {
            default-cache-ttl = 86400;
            max-cache-ttl = 14 * 86400;
            default-cache-ttl-ssh = 86400;
            max-cache-ttl-ssh = 7 * 86400;
          };
          apply = value: default // value;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = if (isXorgEnabled config) then pkgs.pinentry-gtk2 else pkgs.pinentry-tty;
        settings = cfg.agent-settings;
      };
    };
  };
}
