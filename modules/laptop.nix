# this is for my custom homelab setup
# differentiate later
{ modulesPath
, lib
, pkgs
, inputs
, ...
}: {

  networking = {
    networkmanager.enable = true;
    hostName = "smolfw13";
  };
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      package = pkgs.bluez;
    };
  };
  users = {
    #mutableUsers = lib.mkForce false;
    mutableUsers = true;
    users.lain = {
      # add HashedPassword( in sops for even more security )
      initialHashedPassword = "$6$0o1YuLY57h96oMrF$KSt/VqRC9Nz4nbz5L03HaeJu5UucCNyBo/OiQYiaOcBhU/PLqW4/wD4xJAP32Oc45sASDT.DigNDYzU8meKTZ/";
      extraGroups = [
        "wheel"
      ];
      shell = pkgs.zsh;
      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = let ssh_keys = (builtins.fetchurl { url = "https://github.com/SmolPatches.keys"; sha256 = "0r8zl19lg67r7bmqqibxf46vb1081l8z7c9hr9pyc617123nrpfg"; }); in [ ssh_keys ]; # point key files to the thing in nix_store
      packages = with pkgs; [
        obsidian
        zip
        unzip
        p7zip
        binutils
        helix
        tradingview
        killall
        pulsemixer
        eza
        ssh-to-age
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    mkvtoolnix-cli
    dracula-theme
    dracula-icon-theme
    distrobox
    wget
    hwinfo
    swaybg
    swaylock
    swayidle
    xdg-utils
    mpv
    firefox-wayland
    pavucontrol
    wl-clipboard
    usbutils
    pciutils
    man-pages
    powertop # not using auto tune because tlp does it
    man-pages-posix
  ] ++ [ ripgrep fd tree file binwalk bat ] ++
  [ tcpdump nmap netcat-openbsd lsof dig tshark ]; # network monitoring
  fonts.packages = (with pkgs.nerd-fonts; [
    fira-code
    caskaydia-mono
    fira-mono
    commit-mono
  ]);
  services = {
    xserver = {
      #videoDrivers = [ "amdgpu" ];
      desktopManager.gnome.enable = true;
      enable = true;
    };
    displayManager = {
      ly = {
        enable = true;
        settings = {
          vi_mode = true;
        };
      };
    };
    #tlp.enable = true;
    blueman.enable = true;
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
      wireplumber.extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
        };
      };
    };
  };
  programs = {
    zsh.enable = true;
    git.enable = true;
    waybar.enable = true;
    hyprland = {
      # use hyprland from flake
      enable = true;
      xwayland = {
        enable = true; #for steam
      };
    };
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
      };
    };
  };
  security = {
    polkit.enable = true; # needed for hyprland
  };
  environment = {
    variables = {
      GTK_THEME = "Dracula:dark";
    };
  };
  documentation = {
    enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
  };
}
