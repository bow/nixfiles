{
  lib,
  ...
}:
let
  inherit (lib) types;
in
{
  options.nixsys.home.theme = {
    active = lib.mkOption {
      default = null;
      type = types.nullOr types.attrs;
    };
  };
}
