{
  config,
  lib,
  pkgs,
  outputs,
  user,
  asStandalone ? true,
  ...
}:
let
  inherit (lib) types;
  libcfg = lib.nixsys.home;

  desktopEnabled = libcfg.isDesktopEnabled config;

  cliPackages = with pkgs; [
    age
    asdf-vm
    aria2
    asciidoctor-with-extensions
    btop
    cloc
    coreutils-full
    curl
    curlie
    distrobox
    dmidecode
    dnsmasq
    dnsutils
    dos2unix
    dua
    duf
    elinks
    entr
    ethtool
    eza
    fd
    file
    findutils
    gh
    glow
    gnugrep
    gnupatch
    gnupg
    gnused
    grpcurl
    gzip
    hexyl
    htop
    iftop
    imagemagick
    inetutils
    iotop
    ipcalc
    iperf3
    iproute2
    jq
    just
    ldns
    libvirt
    lld
    lldb
    lshw
    ltrace
    lzip
    minify
    mtr
    nerdctl
    nh
    nixfmt-rfc-style
    nmap
    nodejs
    ntfs3g
    p7zip
    packer
    pass
    pciutils
    pdftk
    poetry
    pv
    pyenv
    python3
    qemu
    restic
    rustup
    sequoia-sq
    socat
    strace
    stylua
    sysstat
    terraform
    texlab
    texliveFull
    tmux
    tree
    unrar
    unzip
    usbutils
    vim
    virt-manager
    virt-viewer
    weechat
    wget
    which
    whois
    wrk
    xan
    xz
    yazi
    zip
    zstd
  ];

  desktopPackages = with pkgs; [
    # File storage.
    dropbox

    # PDF reader.
    evince

    # Web browser.
    firefox

    # Web browser.
    google-chrome

    # Text editor.
    geany

    # Disk partition editor.
    gparted

    # Screnshot tool.
    maim

    # Image viewer.
    nomacs

    # Markdown-based knowledge base.
    obsidian

    # Mail client.
    protonmail-bridge

    # Music player.
    spotify

    # Image viewer.
    sxiv

    # Logitech peripherals.
    solaar

    # Synology.
    synology-drive-client

    # Email client.
    thunderbird-latest

    # Official Todoist app.
    todoist-electron

    # Encryption tooling.
    veracrypt

    # Video player.
    vlc

    # File explorer + plugins.
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-dropbox-plugin
    xfce.thunar-volman

    # PDF reader.
    zathura
  ];
in
{
  options.nixsys.home.system = lib.mkOption {
    default = { };
    description = "Container for copied system-level settings";
    type = types.submodule {
      freeformType = types.attrsOf types.anything;
    };
  };

  config = {
    home = {
      stateVersion = "25.05";
      username = user.name;
      homeDirectory = user.home-directory;
      packages = cliPackages ++ (lib.optionals desktopEnabled desktopPackages);
      preferXdgDirectories = true;
    };

    nixpkgs = lib.mkIf asStandalone {
      overlays = builtins.attrValues outputs.overlays;
      config.allowUnfree = true;
    };

    programs = {
      home-manager.enable = true;
      uv.enable = true;
    };

    # Reload systemd units on config change.
    systemd.user.startServices = "sd-switch";
  };
}
