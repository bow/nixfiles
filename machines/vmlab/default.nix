{
  inputs,
  outputs,
  lib,
  ...
}:
let
  inherit (lib.nixsys) enabled enabledWith;
  primaryUserName = "bow";
  hostName = "vmlab";
in
{
  system.stateVersion = "25.05";

  imports = [
    outputs.nixosModules.all
    ./hardware.nix
    ./disk.nix
    inputs.disko.nixosModules.disko
  ];

  nixsys = {
    system = {
      kind = "workstation";
      boot.systemd = enabled;
      nix.nixos-cli = enabled;
    };
    users = {
      mutable = false;
      main = {
        name = "bow";
        trusted = true;
        home-manager = enabled;
        desktop = {
          i3 = enabled;
          greetd = enabledWith {
            settings.auto-login = true;
          };
        };
        extra-groups = [
          "docker"
          "libvirtd"
          "networkmanager"
          "wheel"
        ];
      };
    };
  };

  home-manager.users.bow.local.i3.modifierKey = "Mod1";

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
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
      "${primaryUserName}" = {
        hashedPassword = "$6$iKfcfUgbNFtHGTRj$Ie1425E0xPZG.FUlw4KLsofQdTL2rELJ17xtJKuUD7AifiEUZoE3jQag2lDG7ahfgkHjJPTFNuZETUFHbMuJ01";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILetxdkGYGooOnymLSctz3B+QxTGonnAwQbSwFoIa9UR openpgp:0xBBA92D16"
        ];
      };
    };
  };

  virtualisation.docker.enable = true;
}
