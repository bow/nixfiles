{
  config,
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixsys) mkOpt;
  libcfg = lib.nixsys.nixos;

  mainUserDefined = libcfg.isMainUserDefined config;

  cfg = config.nixsys.users;
in
{
  options.nixsys.users = {
    mutable = mkOpt types.bool false "Sets users.mutableUsers in NixOS config";
    main = mkOpt (types.submodule {
      options = {
        name = mkOpt types.str null "User name of the main user";
        full-name = mkOpt types.str "" "Full name of the main user";
        email = mkOpt types.str "" "Email of the main user";
        home-directory = mkOpt types.str "/home/${cfg.main.name}" "Path to the user's home directory";
        extra-groups = mkOpt (types.listOf types.str) [ ] "Additional groups of the user";
        shell = mkOpt (types.enum [ "bash" ]) "bash" "Login shell of the user";
        trusted = mkOpt types.bool false "Whether to add the user to the trusted user list or not";
      };
    }) { } "Main user configurations";
    programs = mkOpt (types.submodule { }) { } "Programs common for all users";
  };

  config = lib.mkIf mainUserDefined {

    users = {
      mutableUsers = cfg.mutable;
      users.${cfg.main.name} = {
        description = cfg.main.full-name;
        extraGroups = cfg.main.extra-groups ++ (lib.optionals cfg.main.trusted [ "wheel" ]);
        isNormalUser = true;
      };
    };

    nix.settings.trusted-users = lib.optionals cfg.main.trusted [ "${cfg.main.name}" ];
  };
}
