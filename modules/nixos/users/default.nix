{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  inherit (lib.nixsys) mkOpt mkOpt';

  cfg = config.nixsys.users;

  desktopSubmodule = types.submodule {
    options = {
      windowManager = mkOpt windowManagerSubmodule { } "Window manager configurations";
      loginManager = mkOpt loginManagerSubmodule { } "Login manager configurations";
    };
  };

  windowManagerSubmodule = types.submodule {
    options = {
      name = mkOpt (types.enum [ "i3" ]) "i3" "The name of the desktop window manager";
    };
  };

  loginManagerSubmodule = types.submodule {
    options = {
      name = mkOpt (types.enum [ "greetd" ]) "greetd" "The name of the login manager";
      settings = mkOpt types.attrs { } "The login manager settings";
    };
  };

  mainUserSubmodule = types.submodule {
    options = {
      name = mkOpt' types.str "The name of the main user.";
      homeDir = mkOpt types.str "/home/${cfg.main.name}" "Path to home directory";
      extraGroups = mkOpt (types.listOf types.str) [ ] "Additional groups of the user";
      trusted = mkOpt types.bool false "Whether to add the user to the trusted user list or not";
      desktop = mkOpt desktopSubmodule { } "Desktop configurations";
    };
  };
in
{
  options.nixsys.users = {
    enable = mkEnableOption "Enable users module";
    mutable = mkOpt types.bool false "Sets users.mutableUsers in NixOS config";
    main = mkOpt mainUserSubmodule { } "Main user configurations";
  };

  config =
    let
      inherit (lib) hasAttr;

      i3Enabled = cfg.main.desktop.windowManager.name == "i3";
      greetdEnabled = cfg.main.desktop.loginManager.name == "greetd";
      autologinEnabled =
        greetdEnabled
        && (with cfg.main.desktop.loginManager; hasAttr "autoLogin" settings && settings.autoLogin);
    in
    mkIf (cfg.enable && cfg.main.name != null) {
      users = {
        mutableUsers = cfg.mutable;
        users.${cfg.main.name} = {
          inherit (cfg.main) extraGroups;
          isNormalUser = true;
        };
      };

      nix.settings.trusted-users = lib.optionals cfg.main.trusted [ "${cfg.main.name}" ];

      # window manager: i3
      environment.pathsToLink = mkIf i3Enabled [ "/libexec" ];
      services.xserver = mkIf i3Enabled {
        enable = true;
        autorun = false;
        displayManager.startx = {
          enable = true;
        };
        desktopManager = {
          xterm.enable = false;
        };
        windowManager.i3 = {
          enable = true;
        };
      };
      services.displayManager.defaultSession = mkIf i3Enabled "none+i3";
      services.displayManager.autoLogin = mkIf autologinEnabled {
        enable = true;
        user = cfg.main.name;
      };
      programs.i3lock.enable = i3Enabled;
      security.pam.services.i3lock-color.enable = i3Enabled;

      # login manager: greetd
      services.greetd = mkIf greetdEnabled {
        enable = true;
        settings = {
          terminal.vt = 7;
          default_session = mkIf i3Enabled {
            command = "${pkgs.xorg.xinit}/bin/startx";
          };
          initial_session = mkIf (autologinEnabled && i3Enabled) {
            command = "${pkgs.xorg.xinit}/bin/startx";
            user = cfg.main.name;
          };
        };
      };
    };
}
