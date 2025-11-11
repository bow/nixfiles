{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.nixsys) mkOpt mkOpt';

  cfg = config.nixsys.users;
in
{
  options.nixsys.users = {
    mutable = mkOpt types.bool false "Sets users.mutableUsers in NixOS config";
    main = mkOpt (types.submodule {
      options = {
        name = mkOpt' types.str "The name of the main user.";
        home-directory = mkOpt types.str "/home/${cfg.main.name}" "Path to home directory";
        extra-groups = mkOpt (types.listOf types.str) [ ] "Additional groups of the user";
        trusted = mkOpt types.bool false "Whether to add the user to the trusted user list or not";
        home-manager.enable = mkEnableOption "Enable nixsys.users.main.home-manager module";
      };
    }) { } "Main user configurations";
  };

  config = mkIf (cfg.main.name != null) {

    users = {
      mutableUsers = cfg.mutable;
      users.${cfg.main.name} = {
        extraGroups = cfg.main.extra-groups;
        isNormalUser = true;
      };
    };

    nix.settings.trusted-users = lib.optionals cfg.main.trusted [ "${cfg.main.name}" ];
  };
}
