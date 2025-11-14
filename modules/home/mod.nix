{ lib, ... }:
{
  all = {
    imports = lib.nixsys.listDefaultNixFilesRecursive ./.;
  };
}
