{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkForce
    mkIf
    mkOption
    types
    ;
  inherit (lib.nixsys) mkOpt;
  inherit (lib.nixsys.cfg) isMainUserDefined isXorgEnabled;

  hostname = config.nixsys.system.hostname;
  mainUser = config.nixsys.users.main;
  cfg = config.nixsys.system.networking.networkmanager;
in
{
  options.nixsys.system.networking.networkmanager = mkOption {
    default = { };
    type = types.submodule {
      options = {
        enable = mkEnableOption "nixsys.system.networking.networkmanager";
        dns = mkOpt types.str "default" "Sets networking.networkmanager.dns";
        insert-nameservers =
          mkOpt (types.listOf types.str) [ ]
            "Sets networking.networkmanager.insertNameservers";
        append-nameservers =
          mkOpt (types.listOf types.str) [ ]
            "Sets networking.networkmanager.appendNameservers";
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = hostname;
      networkmanager.enable = true;
      networkmanager.plugins = [
        pkgs.networkmanager-openvpn
      ];
      networkmanager.dns = cfg.dns;
      networkmanager.appendNameservers = cfg.append-nameservers;
      networkmanager.insertNameservers = cfg.insert-nameservers;
    };

    users.users = mkIf (isMainUserDefined config) {
      ${mainUser.name}.extraGroups = [ "networkmanager" ];
    };

    systemd.services.NetworkManager-wait-online.enable = mkForce false;
    programs.nm-applet.enable = mkIf (isXorgEnabled config) true;
  };
}
