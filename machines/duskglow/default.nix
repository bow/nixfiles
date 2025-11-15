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
      hostname = "duskglow";
      kind = "workstation";

      boot.systemd = enabled;
      networking.networkmanager = enabled;
      nix.nixos-cli = enabled;
    };
    users.main = {
      name = "bow";
      trusted = true;
      home-manager = enabledWith {
        desktop.i3 = enabled;
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
        "wheel"
      ];
    };
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

  users = {
    users = {
      root = {
        hashedPassword = "$6$cgJT.91qlswKdIud$r0.H/NLTLAKo8u8jkZZH2tY8PBLaFygL436FYnGcRJh5hTD.PpX7o94/yTdipcKKSxQjrhVB02OS8Wd3knmqC.";
      };
      "${nixsys.users.main.name}" = {
        hashedPassword = "$6$iKfcfUgbNFtHGTRj$Ie1425E0xPZG.FUlw4KLsofQdTL2rELJ17xtJKuUD7AifiEUZoE3jQag2lDG7ahfgkHjJPTFNuZETUFHbMuJ01";
      };
    };
  };

  virtualisation.docker.enable = true;
}
