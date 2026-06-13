{ config, pkgs, inputs, ... }: 

{
	home.username = "rshekar";
	home.homeDirectory = "/home/rshekar";
	home.stateVersion = "26.05";

	programs = {
		zsh = {
		  enable = true;
		  shellAliases = {
		   hex = "echo from zsh";
		  };
		};

		git = {
		  enable = true;
		  settings = {
			user = {
			name = "Raj Shekar S";
			email = "rajshekarwork@gmail.com";
			};
		  };
		  extraConfig = {
			init.defaultBranch = "main";
		  };
		};
		
		alacritty.enable = true;
		fuzzel.enable = true;
		swaylock.enable = true;
		waybar.enable = true;

	};
	services = {
	  mako.enable = true;
	  swayidle.enable = true;
	  polkit-gnome.enable = true;
	};

	home.packages = with pkgs; [
	  waypaper
	  swaybg
	  awww
	  gh
	  xwayland-satellite
	  inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
	];

}
