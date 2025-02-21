# nixos-anywhere-examples

Checkout the [flake.nix](flake.nix) for examples tested on different hosters.

# how to run on a new machine
boot nixos installer
run from other machine
```nix run github:nix-community/nixos-anywhere -- --flake '.#framework' --target-host nixos@192.168.1.155```
# how to use once installed
```nixos-rebuild switch --flake . --use-remote-sudo```

