{
  ...
}:
{
  /**
    Return whether the current config is for a workstation.
  */
  hasProfileWorkstation = config: config.nixsys.system.profile == "workstation";
}
