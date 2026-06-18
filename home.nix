{
  config,
  pkgs,
  inputs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    niri = "niri";
    nvim = "nvim";
    ghostty = "ghostty";
    swaylock = "swaylock";
    "starship.toml" = "starship.toml";
  };
in

{
  home = {
    username = "rshekar";
    homeDirectory = "/home/rshekar";
    stateVersion = "26.05";

    packages = with pkgs; [
      pfetch-rs
      fastfetch
      fzf
      zoxide
      ripgrep
      gcc
      nodejs
      cmatrix
      rustup
      direnv
      nix-direnv
      waypaper
      swaybg
      awww
      gh
      xwayland-satellite
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      btop
      brightnessctl
      zed-editor
      bun
      obsidian
      chromium
      graphite
    ];
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initContent = ''
              if [ -f ~/nixos/config/zsh/.zshrc ]; then
                source ~/nixos/config/zsh/.zshrc
              fi
        	    '';

      shellAliases = {
        build-nix = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
        arch = "distrobox enter arch";
        dots = "cd ~/nixos";
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Raj Shekar S";
          email = "rajshekarwork@gmail.com";
        };
        init = {
          defaultBranch = "main";
        };
      };
    };

    gh.enable = true;
    ghostty.enable = true;
    fuzzel.enable = true;
    swaylock.enable = true;
    waybar.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  ## Web Apps
  # Notion
  home.file.".local/share/applications/notion.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Notion
    Comment=Open Notion as a Web App
    Exec=chromium --app="https://notion.so" --new-window --ozone-platform=wayland
    Icon=notion
    Terminal=false
    Categories=Network;WebBrowser;
  '';

  home.file.".local/share/applications/whatsapp.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=WhatsApp
    Comment=Open WhatsApp Web as a Web App
    Exec=chromium --app="https://web.whatsapp.com" --new-window --ozone-platform=wayland
    Icon=whatsapp
    Terminal=false
    Categories=Network;WebBrowser;
  '';

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  services = {
    mako.enable = true;
    swayidle.enable = true;
    polkit-gnome.enable = true;
    vicinae = {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };
    };
  };

}
