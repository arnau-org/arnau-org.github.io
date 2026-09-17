{ config, pkgs, lib, ... }:

{
  home.username = "antoni";
  home.homeDirectory = "/home/antoni";


  # Caelestia

  programs.caelestia = {
    enable = true;
    cli.enable = true;

    # Indico a Caelestia quin terminal i editor ha de fer servir.
    settings = {
      terminal = "kitty";
      editor   = "codium";
    };
  };

  xdg.configFile."caelestia/hypr-user.lua".text = ''
    -- Configuració personal d'Hyprland.

    -- Agent de polkit, necessari per a diàlegs d'autenticació gràfics.
    hl.on("hyprland.start", function()
      hl.exec_cmd("systemctl --user start hyprpolkitagent")
    end)

    -- Llança l'shell de Caelestia en arrencar Hyprland.
    hl.on("hyprland.start", function()
      hl.exec_cmd("caelestia shell -d")
    end)
    '';

  xdg.configFile."caelestia/hypr-vars.lua".text = ''
    -- Variables personals de Caelestia / Hyprland.
    --
    -- De moment no cal afegir res.
    '';

  # Tema d'icones (Papirus-Dark) i agent de polkit

  home.packages = with pkgs; [
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

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
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

  # Versió d'estat de Home Manager

  home.stateVersion = "26.05";
}
