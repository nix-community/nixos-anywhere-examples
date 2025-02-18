# this is for my custom homelab setup
# differentiate later
{ config, pkgs, lib }: {

  users = {
    mutableUsers = lib.mkForce false;
    users.lain = {
      # add HashedPassword( in sops for even more security )
      extraGroups = [
        "wheel"
      ];
      shells = pkgs.zsh;
      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = let ssh_keys = (builtins.fetchurl { url = "https://github.com/SmolPatches.keys"; sha256 = ""; }); in [ ssh_keys ]; # point key files to the thing in nix_store
      packages = with pkgs; [
        eza 
        ssh-to-age
      ];
    };
  };
}
