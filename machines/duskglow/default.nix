{
  config,
  inputs,
  outputs,
  pkgs,
  pkgs-unstable,
  pkgs-local,
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
    hostName = "duskglow";
    networkmanager.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: _: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (final) config;
        };
      })
    ];
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
      inherit
        inputs
        outputs
        pkgs-unstable
        pkgs-local
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
      };
    };
  };

  system.stateVersion = stateVersion;
}
