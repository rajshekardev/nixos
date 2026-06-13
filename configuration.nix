{ config, lib, pkgs, ... }:

{
  imports =
    [ 
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

  programs = {
	niri.enable = true;
  zsh.enable = true;
  };

  security = {
	polkit.enable = true;
	pam.services.swaylock = {}; 
  };

  services = {
	gnome.gnome-keyring.enable = true;
  };

  users.users."rshekar" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Raj Shekar";
    extraGroups = [ "networkmanager" "wheel" ];
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
  ];

  environment.sessionVariables = {
	NIXOS_OZONE_WL = "1";
  };
 
	
  fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
  ];

  xdg.portal.config.niri = {
	"org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  system.stateVersion = "26.05";
}
