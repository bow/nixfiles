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
        desktop = mkOpt (desktopSubmoduleFor name) { } "Desktop configurations";
      };
    }
  );

  desktopSubmoduleFor =
    name:
    types.submodule {
      options = {
        enable = mkEnableOption "Enable users.desktop submodule";
        windowManager = mkOpt' (types.enum [ "i3" ]) "The name of the desktop window manager";
        loginManager = mkOpt' (types.enum [ "greetd" ]) "The name of the login manager";
        autoLogin = mkOpt types.bool false "Whether to enable autologin or not";
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
      inherit (lib.nixsys) coalesce headOrNull checkAtMostOne;

      filterUserAttrs = f: filterAttrs (_: user: f user) cfg.normalUsers;
      existUser = f: (filterUserAttrs f) != { };
      existDesktop = f: existUser (user: with user; desktop.enable && (f desktop));

      i3Enabled = existDesktop (desktop: desktop.windowManager == "i3");
      greetdEnabled = existDesktop (desktop: desktop.loginManager == "greetd");
      userNamesWith = f: attrNames (filterUserAttrs f);

      userHasAutoLogin = user: with user.desktop; enable && loginManager == "greetd" && autoLogin;
      autoLoginUserName = headOrNull (
        checkAtMostOne (userNamesWith userHasAutoLogin) "there can only be at most one user with autoLogin"
      );
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
