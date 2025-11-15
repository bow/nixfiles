{
  inputs,
  outputs,
  lib,
  ...
}:
let
  inherit (lib.nixsys) enabled enabledWith;
in
rec {
  system.stateVersion = "25.05";

  imports = [
    outputs.nixosModules.all
    ./hardware.nix
    ./disk.nix
    inputs.disko.nixosModules.disko
  ];

  nixsys = enabledWith {
    system = {
      hostname = "vmlab";
      profile = "workstation";

      boot.systemd = enabled;
      networking.networkmanager = enabled;
      nix.nixos-cli = enabled;
    };
    users.main = {
      name = "bow";
      trusted = true;
      home-manager = enabledWith {
        desktop.i3 = enabledWith {
          mod-key = "Mod1";
        };
        programs = {
          gpg = enabled;
        };
      };
      desktop = {
        i3 = enabled;
        greetd = enabledWith {
          settings.auto-login = true;
        };
      };
      extra-groups = [
        "docker"
        "libvirtd"
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

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

  virtualisation.docker.enable = true;
}
