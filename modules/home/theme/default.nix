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
      default = { };
      type = types.attrs;
    };
  };
}
