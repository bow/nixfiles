{
  ...
}:
{
  /**
    Return whether the current config is for a workstation.
  */
  hasProfileWorkstation = config: config.nixsys.system.profile == "workstation";

  /**
    Return whether the current config enables Xorg.
  */
  isXorgEnabled = config: config.nixsys.users.main.desktop.i3.enable;
}
