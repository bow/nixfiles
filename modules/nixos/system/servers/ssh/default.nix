{
  config,
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixsys) mkOpt;

  cfg = config.nixsys.system.servers.ssh;
in
{
  options.nixsys.system.servers.ssh = {
    enable = lib.mkEnableOption "nixsys.system.servers.ssh";
    generate-hostkey = mkOpt types.bool true "Whether to create an SSH host key or not";
    ports = mkOpt (types.listOf types.port) [ 22 ] "Sets services.openssh.ports";
    allow-users = mkOpt (types.nullOr (
      types.listOf types.str
    )) null "Sets services.openssh.settings.AllowUsers";
    password-authentication =
      mkOpt types.bool true
        "Sets services.openssh.settings.PasswordAuthentication";
    permit-root-login = mkOpt types.str "no" "Sets services.openssh.settings.PermitRootLogin";
    x11-forwarding = mkOpt types.bool false "Sets services.openssh.settings.X11Forwarding";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;

      inherit (cfg) ports;

      hostKeys = lib.optionals cfg.generate-hostkey [
        {
          path = "/etc/ssh/hostkey";
          type = "ed25519";
        }
      ];
      openFirewall = true;

      settings = {
        AllowUsers = cfg.allow-users;
        PasswordAuthentication = cfg.password-authentication;
        PermitRootLogin = cfg.permit-root-login;
        X11Forwarding = cfg.x11-forwarding;
      };
    };
  };
}
