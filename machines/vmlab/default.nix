{
  config,
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.nixsys) enabledWith;
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

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ ];
    growPartition = true;
    loader = {
      timeout = 1;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
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
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  local.i3 = {
    autoLoginUserName = primaryUserName;
  };

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
