{
  ...
}:
rec {
  /**
    Return the system hostname. If it is null, an error will be thrown.
  */
  getHostName =
    config:
    let
      name = config.nixsys.system.hostname;
    in
    if name == null then throw "nixsys.system.hostname is undefined" else name;

  /**
    Return the main user. Throw an error if the name is null.
  */
  getMainUser =
    config:
    let
      user = config.nixsys.users.main;
    in
    if user.name == null then throw "nixsys.user.main.name is undefined" else user;

  /**
    Return the main user if its name is not null. Otherwise return null.
  */
  getMainUserOrNull =
    config:
    let
      user = config.nixsys.users.main;
    in
    if user.name == null then null else user;

  /**
    Return the name of the main user. If it is null, an error will be thrown.
  */
  getMainUserName = config: (getMainUser config).name;

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
  isI3Enabled = config: config.nixsys.users.main.session.i3.enable;

  /**
    Return whether the current config enables i3.
  */
  isXorgEnabled = config: isI3Enabled config;
}
