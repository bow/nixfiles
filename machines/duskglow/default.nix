{
  config,
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.nixsys) enabled enabledWith;
  primaryUserName = "bow";
  hostName = "duskglow";
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
    system = {
      boot.systemd = enabled;
    };
    users = enabledWith {
      mutable = false;
      normalUsers = {
        "${primaryUserName}" = {
          trusted = true;
          extraGroups = [
            "docker"
            "libvirtd"
            "networkmanager"
            "wheel"
          ];
        };
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  local.i3 = {
    autoLoginUserName = primaryUserName;
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "startx";
        user = primaryUserName;
      };
      default_session = initial_session;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      asStandalone = false;
      userName = primaryUserName;
    };
  };

  users = {
    users = {
      root = {
        hashedPassword = "$6$cgJT.91qlswKdIud$r0.H/NLTLAKo8u8jkZZH2tY8PBLaFygL436FYnGcRJh5hTD.PpX7o94/yTdipcKKSxQjrhVB02OS8Wd3knmqC.";
      };
      "${primaryUserName}" = {
        hashedPassword = "$6$iKfcfUgbNFtHGTRj$Ie1425E0xPZG.FUlw4KLsofQdTL2rELJ17xtJKuUD7AifiEUZoE3jQag2lDG7ahfgkHjJPTFNuZETUFHbMuJ01";
      };
    };
  };

  virtualisation.docker.enable = true;
}
