{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (lib.nixsys) mkOpt;
  inherit (lib.nixsys.cfg) isMainUserDefined;

  cfg = config.nixsys.users;
in
{
  options.nixsys.users = {
    mutable = mkOpt types.bool false "Sets users.mutableUsers in NixOS config";
    main = mkOpt (types.submodule {
      options = {
        name = mkOpt types.str null "Name of the main user";
        home-directory = mkOpt types.str "/home/${cfg.main.name}" "Path to the user's home directory";
        extra-groups = mkOpt (types.listOf types.str) [ ] "Additional groups of the user";
        shell = mkOpt (types.enum [ "bash" ]) "bash" "Login shell of the user";
        trusted = mkOpt types.bool false "Whether to add the user to the trusted user list or not";
      };
    }) { } "Main user configurations";
    programs = mkOpt (types.submodule { }) { } "Programs common for all users";
  };

  config = mkIf (isMainUserDefined config) {

    users = {
      mutableUsers = cfg.mutable;
      users.${cfg.main.name} = {
        extraGroups = cfg.main.extra-groups ++ (lib.optionals cfg.main.trusted [ "wheel" ]);
        isNormalUser = true;
      };
    };

    nix.settings.trusted-users = lib.optionals cfg.main.trusted [ "${cfg.main.name}" ];
  };
}
