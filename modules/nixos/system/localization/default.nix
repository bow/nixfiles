{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.nixsys.enable {
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Copenhagen";
  };
}
