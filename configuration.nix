({ modulesPath, lib, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  disko.devices = import ./disk-config.nix {
    inherit lib;
  };
  boot.loader.grub = {
    devices = [ "/dev/sda" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "CHANGE"
  ];
})
