{
  config,
  lib,
  pkgs,
  outputs,
  user,
  asStandalone,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.nixsys.home) isDesktopEnabled;

  cliPackages = with pkgs; [
    age
    asdf-vm
    aria2
    asciidoctor-with-extensions
    autojump
    bat
    btop
    ccls
    clangStdenv
    cloc
    curl
    curlie
    deadnix
    delve
    difftastic
    direnv
    distrobox
    dmidecode
    dnsmasq
    dnsutils
    docker
    docker-buildx
    docker-compose
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
    fzf
    gcc
    gdb
    gh
    ghostty
    glow
    gnugrep
    gnumake
    gnupatch
    gnupg
    gnused
    go
    graphviz
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
    mpd
    mtr
    ncmpcpp
    nerdctl
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
    readline
    restic
    ripgrep
    rustup
    sequoia-sq
    shfmt
    socat
    starship
    stow
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
    uv
    valgrind
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
    zoxide
    zstd

    nh
  ];

  desktopPackages = with pkgs; [
    # PDF reader.
    evince

    # Web browser.
    firefox

    # Text editor.
    geany

    # Disk partition editor.
    gparted

    # Markdown-based knowledge base.
    obsidian

    # Music player.
    spotify

    # Official Todoist app.
    todoist-electron

    # Encryption tooling.
    veracrypt

    # Video player.
    vlc

    # PDF reader.
    zathura
  ];
in
{
  config = {
    home = {
      stateVersion = "25.05";
      username = user.name;
      homeDirectory = user.home-directory;
    };

    home.packages = cliPackages ++ (lib.optionals (isDesktopEnabled config) desktopPackages);

    nixpkgs = mkIf asStandalone {
      overlays = builtins.attrValues outputs.overlays;
      config.allowUnfree = true;
    };

    programs.home-manager.enable = true;

    # Reload systemd units on config change.
    systemd.user.startServices = "sd-switch";
  };
}
