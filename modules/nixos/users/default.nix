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
  inherit (lib.nixsys) mkOpt;

  cfg = config.nixsys.users;
in
{
  options.nixsys.users = mkOption {
    type = types.submodule {
      options = {
        enable = mkEnableOption "Enable users module";
        mutable = mkOpt types.bool false "Sets users.mutableUsers in NixOS config";
        normalUsers = mkOption {
          description = "Normal user configurations";
          default = { };
          type = types.attrsOf (
            types.submodule (
              { name, ... }:
              {
                options = {
                  name = mkOpt types.str name "User name";
                  homeDir = mkOpt types.str "/home/${name}" "Path to home directory";
                  extraGroups = mkOpt (types.listOf types.str) [ ] "Additional groups of the user";
                  trusted = mkOpt types.bool false "Whether to add the user to the trusted user list or not";
                };
              }
            )
          );
        };
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
    };
}
