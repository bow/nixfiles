{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [
    ./i3.nix
  ];

  home.packages =
    let
      fontPkgs = with pkgs; [
        font-awesome
        iosevka
      ];

      appPkgs = with pkgs; [
        # PDF reader.
        evince

        # Image viewer.
        feh

        # Web browser.
        firefox

        # Text editor.
        geany

        # Terminal emulator.
        ghostty

        # Disk partition editor.
        gparted

        # Screnshot tool.
        maim

        # Markdown-based knowledge base.
        obsidian

        # Temperature-based screen light adjuster.
        redshift

        # Music player.
        spotify

        # Official Todoist app.
        todoist-electron

        # Encryption tooling.
        veracrypt

        # PDF reader.
        zathura

        # Video player.
        vlc
      ];
    in
    fontPkgs ++ appPkgs;
}
