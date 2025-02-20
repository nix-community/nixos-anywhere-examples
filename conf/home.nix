{ config, pkgs, ... }:
let
  useEmacs = false;
  useNvim = false;
  useMoar = true;
  enableManColors = true;
  defaultEditor = if useEmacs then "emacsclient" else if useNvim then "nvim" else "hx";
in
{

  # TODO
  # configure wofi/rofi
  # eww
  # home-manager.users.rob = {
  /* The home.stateVersion option does not have a default and must be set */
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    lua-language-server # for neovim config
    neofetch
    rust-analyzer
    discord
    mako # notifications for wayland
    eza
    localsend
    yaml-language-server
    zls
    nil
    nixpkgs-fmt
    moar
    yacreader
    htop
    qbittorrent
    keepassxc
    tmux
    rpcs3
    #x org packages
    rofi
    #wayland packages
    wofi
  ] ++ (with nodePackages; [ bash-language-server vscode-langservers-extracted ]);
  programs = {
    git = {
      enable = true;
      ignores = [ "*.*~" "#*#" ];
      userEmail = ""; # sops secret
      userName = "smolpatches";
      aliases = {
        l1 = "log --oneline";
        last = "log -1 HEAD";
      };
      extraConfig = {
        core = {
          defaultBranch = "trunk";
          #editor = defaultEditor;
        };
      };
      difftastic = {
        enable = true;
        background = "dark";
      };
    };
    tmux = {
      # comes with preset binding, i don't want it.
      enable = false;
    };
    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      extraPackages = epkgs: with epkgs; [ tsc tree-sitter-langs tree-sitter vterm ];
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "vicmd";
      shellAliases = {
        ll = "eza -l --icons";
        ls = "eza --icons";
      };
      initExtra = ''
        PATH=$PATH:~/.local/bin/
        PATH=$PATH:~/.config/emacs/bin/
        function killwb {
          ps aux | grep waybar$ | awk '{print $2}' | xargs kill
        }
        ${builtins.readFile ./extras.zsh}
      '';
      profileExtra = ''
        "${builtins.readFile ./extras.zsh}"
      '';
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [ "--exact" ];
    };
    starship = {
      enable = false;
      enableZshIntegration = false;
    };
    alacritty = {
      enable = true;
    };
    zathura = {
      enable = true;
    };
    lf = {
      enable = true;
    };
    rofi = {
      enable = true;
    };
    waybar = {
      enable = false;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };
  home.sessionVariables = {
    EDITOR = defaultEditor;
    PAGER = pkgs.lib.mkForce (if useMoar then "${pkgs.lib.getExe pkgs.moar}" else "less");
    GROFF_NO_SGR = if enableManColors then 1 else 0;
  };
  services = {
    emacs = {
      enable = true;
      startWithUserSession = true;
    };
  };
  xdg = {
    configFile = {
      "hypr" = { source = ./hypr; };
      "wallpapers" = { source = ./wallpapers; };
      "zathura" = { source = ./zathura; };
      "tmux" = { source = ./tmux; };
      "helix" = { source = ./helix; };
      "alacritty" = { source = ./alacritty; };
    };
  };
  # desktopEntries = {
  # steam = {
  # name = "Steam";
  # exec = "steam -w 2160 -h 1440 %U";
  # type = "Application";
  # categories = [ "Game" ];
  # terminal = false;
  # mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink" ];
  # prefersNonDefaultGPU = true;
  # };
  # };
  # this was a test idek what this does
  # https://rycee.gitlab.io/home-manager/options.html#opt-nixpkgs.overlays
  nixpkgs.overlays = [
    (final: prev: {
      openssh = prev.openssh.override {
        hpnSupport = true;
        withKerberos = true;
        kerberos = final.libkrb5;
      };
    })
  ];
}
