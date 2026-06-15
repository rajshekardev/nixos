{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.displayManager.ly.enable = true;

  systemd.user.services = {
    niri.enableDefaultPath = false;
    polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

  powerManagement.cpuFreqGovernor = "performance";

  programs = {
    niri.enable = true;
    zsh.enable = true;
    kdeconnect.enable = true;
    xppen.enable = true;
    gamemode.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        fuse3
        alsa-lib
        libGL
        libX11
        libXi
        libXtst
        libXrandr
        libXcursor
        libXcomposite
        libXdamage
        libXext
        libXfixes
        libXrender
        libXt
        openssl
        glib
      ];
    };
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = { };
  };

  services = {
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
    };
    gvfs.enable = true;
    udisks2.enable = true;
    blueman.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "google-chrome"
      "obsidian"
      "steam"
      "steam-unwrapped"
    ];

  users.users."rshekar" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Raj Shekar";
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
    ];

    packages = with pkgs; [
      tree
      zsh
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl
    unzip
    neovim
    ghostty
    distrobox
    power-profiles-daemon
    hydralauncher
    wl-clipboard
    nautilus
    udiskie
    bluetui
    vulkan-tools
    pavucontrol
    blender
    android-tools
    android-studio
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "x11";
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  boot.kernelModules = [
    "ip_tables"
    "iptable_nat"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override {
        extraArgs = "-cef-disable-gpu-compositing";
      };
    })
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "https://cache.garnix.io?priority=10"
      "https://vicinae.cachix.org?priority=20"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
    connect-timeout = 10;
    download-attempts = 5;
    fallback = true;
    narinfo-cache-positive-ttl = 300;
    stalled-download-timeout = 60;
    trusted-users = [
      "root"
      "rshekar"
    ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  system.stateVersion = "26.05";
}
