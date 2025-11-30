{
  inputs,
  outputs,
  lib,
  user,
  ...
}:
let
  inherit (lib.nixsys) enabled enabledWith;
in
rec {
  system.stateVersion = "25.05";

  imports = [
    outputs.nixosModules.nixsys
    ./hardware.nix
    ./disk.nix
    inputs.disko.nixosModules.disko
  ];

  nixsys = enabledWith {
    system = {
      hostname = "vmlab";
      profile = "workstation";
      virtualized = enabledWith {
        guest-type = "qemu";
      };

      boot.systemd = enabled;
      networking.networkmanager = enabled;
      nix.nixos-cli = enabled;
      servers.ssh = enabled;
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
        desktop.i3 = enabledWith {
          mod-key = "Mod1";
        };
        devel = enabled;
        theme.north-01 = enabled;
      };
    };
  };

  users = {
    users = {
      root = {
        hashedPassword = "$6$cgJT.91qlswKdIud$r0.H/NLTLAKo8u8jkZZH2tY8PBLaFygL436FYnGcRJh5hTD.PpX7o94/yTdipcKKSxQjrhVB02OS8Wd3knmqC.";
      };
      "${nixsys.users.main.name}" = {
        hashedPassword = "$6$iKfcfUgbNFtHGTRj$Ie1425E0xPZG.FUlw4KLsofQdTL2rELJ17xtJKuUD7AifiEUZoE3jQag2lDG7ahfgkHjJPTFNuZETUFHbMuJ01";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILetxdkGYGooOnymLSctz3B+QxTGonnAwQbSwFoIa9UR openpgp:0xBBA92D16"
        ];
      };
    };
  };
}
