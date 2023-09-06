{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.disko.url = github:nix-community/disko;
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, disko, ... }@attrs: {
    nixosConfigurations.hetzner-cloud = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ({modulesPath, config, lib, pkgs, ... }: {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            (modulesPath + "/profiles/qemu-guest.nix")
            disko.nixosModules.disko
          ];
          disko.devices = import ./disk-config.nix {
            lib = nixpkgs.lib;
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
         
          environment.systemPackages = map lib.lowPrio [
            pkgs.curl
            pkgs.gitMinimal
          ];  
        })
      ];
    };
  };
}
