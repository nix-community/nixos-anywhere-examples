{ modulesPath
, lib
, pkgs
, ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./modules/common.nix
    ./modules/fs/fw13.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    splashImage = ./assets/tatami.jpg;
    device = "nodev";
    useOSProber = true;
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    #"CHANGE"
  ];

  system.stateVersion = "24.11";
}
