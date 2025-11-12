{
  pkgs,
  ...
}:
{
  imports = [
    ./ghostty.nix
  ];

  home.packages = with pkgs; [
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
}
