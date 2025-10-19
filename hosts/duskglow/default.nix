{
  config,
  inputs,
  pkgs,
  stateVersion,
  ...
}:
{
  imports = [
    ../common

    ./hardware-configuration.nix
    "${inputs.disko}/module.nix"
    ./disk-configuration.nix
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
    supportedFilesystems = [ "btrfs" ];
    tmp.cleanOnBoot = true;
  };

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v20n.psf.gz";
    keyMap = "us";
    packages = [ pkgs.terminus_font ];
  };

  environment = {
    systemPackages = with pkgs; [
      curl
      findutils
      file
      fzf
      gcc
      gdb
      git
      gnugrep
      gnumake
      gnupg
      gnused
      home-manager
      jq
      neovim
      readline
      ripgrep
      unzip
      vim
      wget
    ];
    variables = {
      EDITOR = "nvim";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

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

  services = {
    btrfs = {
      autoScrub = {
        enable = true;
        fileSystems = [ "/" ];
        interval = "monthly";
      };
    };
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  time.timeZone = "Europe/Copenhagen";

  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "$6$cgJT.91qlswKdIud$r0.H/NLTLAKo8u8jkZZH2tY8PBLaFygL436FYnGcRJh5hTD.PpX7o94/yTdipcKKSxQjrhVB02OS8Wd3knmqC.";
      };
      bow = {
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
