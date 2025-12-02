{
  inputs,
  outputs,
  lib,
  user,
  hostname,
  ...
}:
let
  inherit (lib.nixsys) enabled enabledWith;
in
{
  system.stateVersion = "25.05";

  imports = [
    outputs.nixosModules.nixsys
    inputs.disko.nixosModules.disko
    ./disk.nix
  ];

  nixsys = enabledWith {
    system = {
      inherit hostname;
      profile = "workstation";

      boot.systemd = enabled;
      networking.networkmanager = enabled;
      nix.nixos-cli = enabled;
      virtualization.docker = enabled;
    };
    users.main = {
      inherit (user)
        name
        full-name
        email
        city
        timezone
        ;
      trusted = true;
      session.greetd = enabledWith {
        settings.auto-login = true;
      };
      home-manager = enabledWith {
        desktop.i3 = enabled;
        devel = enabled;
        theme.north-01 = enabled;
      };
    };
  };
}
