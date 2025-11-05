{
  config,
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.nixsys) attrsByName enabled enabledWith;
  primaryUserName = "bow";
  hostName = "vmlab";
in
{
  system.stateVersion = "25.05";

  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../base/workstation

    ./hardware.nix
    ./disk.nix
    inputs.disko.nixosModules.disko
  ];

  nixsys = {
    system = enabledWith {
      boot.systemd = enabled;
    };
    users = enabledWith {
      normalUsers = attrsByName [
        {
          name = primaryUserName;
          trusted = true;
          extraGroups = [
            "docker"
            "libvirtd"
            "networkmanager"
            "wheel"
          ];
          desktop = enabledWith {
            windowManager = enabledWith {
              name = "i3";
            };
            loginManager = enabledWith {
              name = "greetd";
              settings.autoLogin = true;
            };
          };
        }
      ];
    };
  };

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

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      asStandalone = false;
      userName = primaryUserName;
    };
    users.bow.local.i3.modifierKey = "Mod1";
  };

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
