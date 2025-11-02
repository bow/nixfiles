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
        mutable = mkOption {
          type = types.bool;
          default = false;
          description = "Same as users.mutableUsers in NixOS config";
        };
        normalUsers = mkOption {
          type = types.attrsOf (
            types.submodule (
              { name, ... }:
              {
                options = {
                  name = mkOpt types.str name "User name";
                  homeDir = mkOpt types.str "/home/${name}" "Path to home directory";
                  extraGroups = mkOpt (types.listOf types.str) [ ] "Additional groups of the user";
                  isTrusted = mkOpt types.bool false "Whether to add the user to the trusted user list or not";
                };
              }
            )
          );
          default = { };
          description = "Normal user configurations";
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

      nix.settings.trusted-users = attrNames (
        filterAttrs (_: userCfg: userCfg.isTrusted) cfg.normalUsers
      );
    };
}
