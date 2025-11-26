{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    removeAttrs
    types
    ;

  cfgMainUser = config.nixsys.users.main;
  cfg = cfgMainUser.home-manager;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.nixsys.users.main.home-manager = mkOption {
    default = { };
    type = types.submodule {
      freeformType = types.attrsOf types.anything;
      options = {
        enable = mkEnableOption "nixsys.users.main.home-manager";
        system = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
      };
    };
  };

  config = mkIf cfg.enable {

    home-manager = {

      useGlobalPkgs = true;

      backupFileExtension = "hm-backup";

      extraSpecialArgs = {
        inherit inputs outputs;
        user = {
          inherit (cfgMainUser)
            name
            email
            full-name
            home-directory
            shell
            ;
        };
        theme = {
          desktop.bg = "${pkgs.local.wallpapers.francesco-ungaro-lcQzCo-X1vM-unsplash}/desktop-bg";
          lock-screen = {
            bg = "${pkgs.local.wallpapers.francesco-ungaro-lcQzCo-X1vM-unsplash}/lock-screen-bg";
            font = {
              name = "Titillium";
              package = pkgs.local.titillium-font;
            };
            colors = rec {
              time = light;
              greeter = dark;

              light = "#ffffffff";
              dark = "#1d2021ee";
              ring = "#007c5bff";
              ring-hl = "#e3ac2dff";
              ring-bs = "#d1472fff";
              ring-sep = "#00000000";
            };
          };
        };
        asStandalone = false;
      };

      users.${cfgMainUser.name} = {
        imports = [
          outputs.homeManagerModules.all
          ./home.nix
        ];

        # Everything in cfg that is not `enable` is meant for nixsys.home.
        nixsys.home = removeAttrs cfg [ "enable" ] // {
          # Façade for system-level config.
          system = {
            docker.enable = config.nixsys.system.virtualization.docker.enable;
          };
        };
      };
    };
  };
}
