_:
{
  nixsys = {
    system = {
      servers.ssh.enable = true;
      virtualized = {
        enable = true;
        guest-type = "qemu";
      };
    };
    users.main = {
      home-manager = {
        enable = true;
        desktop.i3 = {
          enable = true;
          mod-key = "Mod1";
        };
      };
    };
  };
}

