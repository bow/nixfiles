{
  ...
}:
{
  /**
    Return the name of the main user. If it is null, an error will be thrown.
  */
  getMainUserName =
    config:
    let
      name = config.nixsys.users.main.name;
    in
    if name == null then throw "nixsys.user.main.name is undefined" else name;

  /**
    Return whether this config defines main user or not.
  */
  isMainUserDefined = config: config.nixsys.users.main.name != null;

  /**
    Return whether the current config is for a workstation.
  */
  hasProfileWorkstation = config: config.nixsys.system.profile == "workstation";

  /**
    Return whether the current config enables Xorg.
  */
  isXorgEnabled = config: config.nixsys.users.main.desktop.i3.enable;
}
