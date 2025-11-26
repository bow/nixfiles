{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkForce
    mkIf
    mkOption
    types
    ;
  inherit (lib.nixsys) mkOpt;
  inherit (lib.nixsys.nixos)
    getHostName
    getMainUserName
    isMainUserDefined
    isXorgEnabled
    ;

  hostName = getHostName config;
  mainUserDefined = isMainUserDefined config;
  mainUserName = getMainUserName config;
  xorgEnabled = isXorgEnabled config;

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
      inherit hostName;
      networkmanager = {
        enable = true;
        plugins = [ pkgs.networkmanager-openvpn ];
        dns = mkDefault cfg.dns;
        appendNameservers = cfg.append-nameservers;
        insertNameservers = cfg.insert-nameservers;
      };
    };

    users.users = mkIf mainUserDefined {
      ${mainUserName}.extraGroups = [ "networkmanager" ];
    };

    systemd.services.NetworkManager-wait-online.enable = mkForce false;
    programs.nm-applet.enable = mkIf xorgEnabled true;
  };
}
