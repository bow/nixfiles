{
  config,
  inputs,
  outputs,
  pkgs,
  pkgs-unstable,
  stateVersion,
  ...
}:
let
  primaryUserName = "bow";
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../base/workstation

    ./hardware.nix
    ./disk.nix
    inputs.disko.nixosModules.disko
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ ];
    growPartition = true;
    initrd = {
      availableKernelModules = [
        "virtio_net"
        "virtio_pci"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
        "9p"
        "9pnet_virtio"
      ];
      kernelModules = [
        "virtio_balloon"
        "virtio_console"
        "virtio_rng"
        "virtio_gpu"
      ];
    };
    loader = {
      timeout = 1;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    tmp.cleanOnBoot = true;
  };

  networking = {
    hostName = "vmlab";
    networkmanager.enable = true;
  };

  programs = {
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
      };
    };
    spice-vdagentd.enable = true;
    qemuGuest.enable = true;
  };

  local.i3 = {
    autoLoginUserName = primaryUserName;
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit
        inputs
        outputs
        pkgs-unstable
        stateVersion
        ;
      asStandalone = false;
      userName = primaryUserName;
    };
  };

  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "$6$cgJT.91qlswKdIud$r0.H/NLTLAKo8u8jkZZH2tY8PBLaFygL436FYnGcRJh5hTD.PpX7o94/yTdipcKKSxQjrhVB02OS8Wd3knmqC.";
      };
      "${primaryUserName}" = {
        hashedPassword = "$6$iKfcfUgbNFtHGTRj$Ie1425E0xPZG.FUlw4KLsofQdTL2rELJ17xtJKuUD7AifiEUZoE3jQag2lDG7ahfgkHjJPTFNuZETUFHbMuJ01";
        isNormalUser = true;
        extraGroups = [
          "docker"
          "libvirtd"
          "networkmanager"
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILetxdkGYGooOnymLSctz3B+QxTGonnAwQbSwFoIa9UR openpgp:0xBBA92D16"
        ];
      };
    };
  };

  virtualisation.docker.enable = true;

  system.stateVersion = stateVersion;
}
