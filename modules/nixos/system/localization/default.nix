{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.nixsys.enable {
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Copenhagen";
  };
}
