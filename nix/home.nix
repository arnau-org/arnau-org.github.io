{ config, pkgs, lib, ... }:

{
  home.username = "antoni";
  home.homeDirectory = "/home/antoni";

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Defineix la variable mainMod
      "$mainMod" = "SUPER";

      # Inicia Caelestia en arrencar Hyprland
      exec-once = [ "caelestia shell -d" ];

      # Dreceres bàsiques
      bind = [
        "$mainMod, Return, exec, kitty"
        "$mainMod, Q, killactive"
        "$mainMod, E, exec, nautilus"
        "$mainMod, B, exec, brave"
        "$mainMod, V, exec, caelestia clipboard"
        ", Super_L, global, caelestia:launcher"
      ];

      input = {
        kb_layout = "es";
        kb_variant = "cat";
      };
    };
  };

  # Caelestia

  programs.caelestia = {
    enable = true;

    # Configuració del servei de systemd (opcional)
    systemd = {
      enable = false; # Si prefereixes iniciar-la des del compositor (Hyprland)
      # target = "graphical-session.target";
      # environment = [];
    };

    # Opcions de la shell (es tradueixen a shell.json)
    settings = {
      # Exemple: indicar el terminal i l'editor
      general.apps.terminal = [ "kitty" ];

      # Exemple de la documentació:
      bar.statusIcons = [
        { id = "lockStatus"; enabled = true; }
        { id = "network"; enabled = true; }
        { id = "bluetooth"; enabled = false; }
        { id = "battery"; enabled = false; }
      ];
      #paths.wallpaperDir = "~/Pictures/Wallpapers";
    };

    # CLI de Caelestia (opcional però recomanat)
    cli = {
      enable = true;
      settings = {
        theme.enableGtk = false;
      };
    };
  };

  # Tema d'icones (Papirus-Dark) i agent de polkit

  home.packages = with pkgs; [
    wl-clipboard
    gnome-disk-utility
    nautilus
    papers
    loupe
    papirus-icon-theme
    hyprpolkitagent
    telegram-desktop
    inkscape
    #euphonica
    #feishin
    shortwave
    gnome-podcasts
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "Papirus-Dark";
    };
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting
    '';

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#argos";
      rebuild-test = "sudo nixos-rebuild test --flake /etc/nixos#argos";
      update = "sudo nix flake update --flake /etc/nixos";
    };
  };

  # Starship

  programs.starship.enable = true;

  # Kitty (terminal)

  programs.kitty = {
    enable = true;
    # Pots afegir configuració addicional aquí:
    # settings = {
    #   background_opacity = "0.95";
    #   font_size = "12.0";
    # };
    # extraConfig = ''
    #   confirm_os_window_close 0
    # '';
  };


  # VSCodium (editor)

  programs.vscodium = {
    enable = true;
    # Extensions que vols instal·lar declarativament.
    # Pots afegir-ne més des de pkgs.vscode-extensions.
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Exemples:
      # dracula-theme.theme-dracula
      # vscodevim.vim
      # yzhang.markdown-all-in-one
      # bbenoist.nix
    ];
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Escriptori";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Baixades";
      music = "${config.home.homeDirectory}/Música";
      pictures = "${config.home.homeDirectory}/Imatges";
      videos = "${config.home.homeDirectory}/Vídeos";
      templates = "${config.home.homeDirectory}/Plantilles";
      publicShare = null; # Opcional: si no vols carpeta pública
    };
  };

  # Versió d'estat de Home Manager

  home.stateVersion = "26.11";
}
