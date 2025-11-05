{
  config,
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

  normalUsersSubmodule = types.submodule (
    { name, ... }:
    {
      options = {
        name = mkOpt types.str name "User name";
        homeDir = mkOpt types.str "/home/${name}" "Path to home directory";
        extraGroups = mkOpt (types.listOf types.str) [ ] "Additional groups of the user";
        trusted = mkOpt types.bool false "Whether to add the user to the trusted user list or not";
        desktop = mkOpt desktopSubmodule { } "Desktop configurations";
      };
    }
  );

  desktopSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Enable users.desktop submodule";
      windowManager = mkOpt windowManagerSubmodule { } "Window manager configurations";
      loginManager = mkOpt loginManagerSubmodule { } "Loginmanager configurations";
    };
  };

  windowManagerSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Enable users.desktop.windowManager submodule";
      name = mkOpt (types.enum [ "i3" ]) "i3" "The name of the desktop window manager";
    };
  };

  loginManagerSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Enable users.desktop.loginManager submodule";
      name = mkOpt (types.enum [ "greetd" ]) "greetd" "The name of the login manager";
      settings = mkOpt types.attrs { } "The login manager settings";
    };
  };
in
{
  options.nixsys.users = mkOption {
    type = types.submodule {
      options = {
        enable = mkEnableOption "Enable users module";
        mutable = mkOpt types.bool false "Sets users.mutableUsers in NixOS config";
        normalUsers = mkOpt (types.attrsOf normalUsersSubmodule) { } "Normal user configurations";
      };
    };
  };

  config =
    let
      inherit (lib)
        attrNames
        filterAttrs
        nameValuePair
        mapAttrs'
        ;
      inherit (lib.nixsys)
        coalesce
        getAttrOr
        headOrNull
        checkAtMostOne
        ;

      usersWith = f: filterAttrs (_: user: f user) cfg.normalUsers;
      existUserWith = f: (usersWith f) != { };
      existDesktopWith = f: existUserWith (user: with user; desktop.enable && (f desktop));

      i3Enabled = existDesktopWith (desktop: with desktop.windowManager; enable && name == "i3");
      greetdEnabled = existDesktopWith (desktop: with desktop.loginManager; enable && name == "greetd");

      userHasAutoLogin =
        user:
        with user.desktop;
        enable && loginManager.enable && (getAttrOr "autoLogin" loginManager.settings false);

      usersWithAutoLogin = (usersWith userHasAutoLogin);

      autoLoginUserName = headOrNull (
        checkAtMostOne (attrNames usersWithAutoLogin) "there can only be at most one user with autoLogin"
      );

      userNamesWith = f: attrNames (usersWith f);
    in
    mkIf cfg.enable {
      users = {
        mutableUsers = cfg.mutable;
        users = mapAttrs' (
          name: user:
          nameValuePair name {
            inherit (user) extraGroups;
            isNormalUser = true;
          }
        ) cfg.normalUsers;
      };

      nix.settings.trusted-users = userNamesWith (user: user.trusted);

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
      services.displayManager.autoLogin = mkIf (i3Enabled && autoLoginUserName != null) {
        enable = true;
        user = autoLoginUserName;
      };
      programs.i3lock.enable = i3Enabled;
      security.pam.services.i3lock-color.enable = i3Enabled;

      # login manager: greetd
      services.greetd = mkIf greetdEnabled {
        enable = true;
        settings = rec {
          terminal.vt = 7;
          default_session = mkIf i3Enabled {
            command = "startx";
            user = coalesce autoLoginUserName "greetd";
          };
          initial_session = mkIf (autoLoginUserName != null) default_session;
        };
      };
    };
}
