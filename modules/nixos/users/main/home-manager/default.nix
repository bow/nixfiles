{
  config,
  lib,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib) mkIf;

  cfgUsers = config.nixsys.users;
  cfg = config.nixsys.users.main.home-manager;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs = {
        inherit inputs outputs;
        user = {
          inherit (cfgUsers.main) name home-directory;
        };
        asStandalone = false;
      };
      users.${cfgUsers.main.name}.imports = [ ./home.nix ];
    };
  };
}
