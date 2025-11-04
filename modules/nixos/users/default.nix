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

      filterUsersWith = f: filterAttrs (_: userCfg: f userCfg) cfg.normalUsers;
      existUserWith = f: builtins.length (builtins.attrNames (filterUsersWith f)) > 0;
      existUserWithWM =
        wm: existUserWith (userCfg: with userCfg; desktop.enable && desktop.windowManager == wm);
      existUserWithLM =
        lm: existUserWith (userCfg: with userCfg; desktop.enable && desktop.loginManager == lm);

      i3Enabled = existUserWithWM "i3";
      greetdEnabled = existUserWithLM "greetd";
      autoLoginUser =
        let
          names = builtins.attrNames (filterUsersWith (userCfg: userCfg.desktop.autoLogin));
        in
        if builtins.length names > 1 then
          throw "there can only be at most one user with autologin"
        else
          (if builtins.length names == 0 then null else builtins.head names);
    in
    mkIf cfg.enable {
      users = {
        mutableUsers = cfg.mutable;
        users = mapAttrs' (
          name: userCfg:
          nameValuePair name {
            inherit (userCfg) extraGroups;
            isNormalUser = true;
          }
        ) cfg.normalUsers;
      };

      nix.settings.trusted-users = attrNames (filterAttrs (_: userCfg: userCfg.trusted) cfg.normalUsers);

      # window manager: i3
      environment.pathsToLink = lib.optionals i3Enabled [ "/libexec" ];
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
      services.displayManager.autoLogin = mkIf i3Enabled {
        enable = true;
        user = "bow";
      };
      programs.i3lock.enable = i3Enabled;
      security.pam.services.i3lock-color.enable = i3Enabled;

      # login manager: greetd
      services.greetd = mkIf greetdEnabled {
        enable = true;
        settings = rec {
          default_session = mkIf i3Enabled {
            command = "startx";
            user = autoLoginUser;
          };
          initial_session = mkIf (autoLoginUser != null) default_session;
        };
      };
    };
}
