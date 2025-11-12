{ lib, ... }:
{
  all = {
    imports = lib.nixsys.lookupDefaultNixFiles ./.;
  };
}
