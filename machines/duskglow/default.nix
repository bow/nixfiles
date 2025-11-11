{
  inputs,
  outputs,
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

    outputs.nixosModules.default
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
        extra-groups = [
          "docker"
          "libvirtd"
          "networkmanager"
          "wheel"
        ];
        desktop = {
          i3 = enabled;
          greetd = enabledWith {
            settings.auto-login = true;
          };
        };
      };
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
