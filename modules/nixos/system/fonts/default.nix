{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.nixsys.enable {
    fonts.enableDefaultPackages = true;
  };
}
