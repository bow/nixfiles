{ lib, ... }:
{
  default = {
    imports = lib.nixsys.lookupDefaultNixFiles ./.;
  };
}
