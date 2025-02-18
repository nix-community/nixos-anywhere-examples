{ config, pkgs, lib }: {
  services.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };
  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };
  services.kubo = {
    enable = true;
  };
  services.fail2ban = {
    # fail2ban recommendations
    # https://nixos.wiki/wiki/Fail2ban
    enable = false;
  };
}
