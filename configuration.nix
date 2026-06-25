{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];
  boot = {

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [
      "ip_tables"
      "iptable_nat"
    ];
  };

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";
  i18n = {

    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    inputMethod = {
      enable = true;
      type = "ibus";
    };
  };
  services = {
    xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    systemd.tmpfiles.rules = [
        "d /var/cache/shared-wallpaper 0755 raj users -"
      ];

    displayManager.plasma-login-manager = {
      enable = true;
      settings = {
        "Greeter][Wallpaper][org.kde.image][General" = {
          Image = "file:///var/cache/shared-wallpaper/current.jpg";
        };
      };
    };
    gnome.gnome-keyring.enable = true;
    gnome.evolution-data-server.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
    };

    gvfs.enable = true;
    udisks2.enable = true;
    blueman.enable = true;

  };

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

  powerManagement.cpuFreqGovernor = "performance";

  programs = {
    niri.enable = true;
    zsh.enable = true;
    kdeconnect.enable = true;
    gamemode.enable = true;
    xppen.enable = true;
    xppen.package = pkgs.xppen_4;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        glib
        openssl
        icu
        libgcc
      ];
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.swaylock = { };
  };

  nixpkgs = {
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
      ];

    config.allowUnfree = true;

    overlays = [
      (final: prev: {
        steam = prev.steam.override {
          extraArgs = "-cef-disable-gpu-compositing";
        };
      })
    ];
  };

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

  environment.systemPackages = with pkgs; [
    curl
    unzip
    neovim
    ghostty
    distrobox
    power-profiles-daemon
    wl-clipboard
    nautilus
    udiskie
    bluetui
    vulkan-tools
    pavucontrol
    blender
    statix
    steam
    nixpkgs-fmt
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland;xcb";
    XMODIFIERS = "@im=ibus";
  };

  virtualisation = {

    waydroid.enable = true;
    waydroid.package = pkgs.waydroid-nftables;

    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [ "https://vicinae.cachix.org" ];
    extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];

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
