# this is for my custom homelab setup
# differentiate later
{ modulesPath
, lib
, pkgs
, ...
}: {

  users = {
    mutableUsers = lib.mkForce false;
    users.lain = {
      # add HashedPassword( in sops for even more security )
      extraGroups = [
        "wheel"
      ];
      shell = pkgs.zsh;
      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = let ssh_keys = (builtins.fetchurl { url = "https://github.com/SmolPatches.keys"; sha256 = "1kdpxy35g3gx850pj6v5450bv59pbn3nr5vkbik7csjp7br7nvn2"; }); in [ ssh_keys ]; # point key files to the thing in nix_store
      packages = with pkgs; [
        eza
        ssh-to-age
      ];
    };
  };
  programs.zsh.enable = true;
}
