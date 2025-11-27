{
  lib,
  ...
}:
let
  inherit (lib) types;
in
{
  options.nixsys.home.devel = lib.mkOption {
    default = { };
    type = types.submodule {
      freeformType = types.attrsOf types.anything;
      options = {
        enable = lib.mkEnableOption "nixsys.home.devel";
      };
    };
  };
}
