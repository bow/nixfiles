{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixsys) mkOpt;
  libcfg = lib.nixsys.nixos;

  hostName = libcfg.getHostName config;
  mainUserDefined = libcfg.isMainUserDefined config;
  mainUserName = libcfg.getMainUserName config;
  xorgEnabled = libcfg.isXorgEnabled config;

  cfg = config.nixsys.system.networking.networkmanager;
in
{
  options.nixsys.system.networking.networkmanager = {
    enable = lib.mkEnableOption "nixsys.system.networking.networkmanager";

    dns = mkOpt types.str "default" "Sets networking.networkmanager.dns";

    append-nameservers = lib.mkOption {
      description = "Sets networking.networkmanager.appendNameservers";
      type = types.listOf types.str;
      default = [ ];
    };

    insert-nameservers = lib.mkOption {
      description = "Sets networking.networkmanager.insertNameservers";
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      inherit hostName;
      networkmanager = {
        enable = true;
        plugins = [ pkgs.networkmanager-openvpn ];
        dns = lib.mkDefault cfg.dns;
        appendNameservers = cfg.append-nameservers;
        insertNameservers = cfg.insert-nameservers;
      };
    };

    users.users = lib.mkIf mainUserDefined {
      ${mainUserName}.extraGroups = [ "networkmanager" ];
    };

    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
    programs.nm-applet.enable = lib.mkIf xorgEnabled true;
  };
}
