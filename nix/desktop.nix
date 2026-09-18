{ config, lib, pkgs, ... }:

{

  # Polkit (necessari per a diàlegs d'autenticació gràfics: muntar USB,
  # gestionar xarxa des de la GUI, etc.)

  security.polkit.enable = true;

  # Portal XDG (captura/compartició de pantalla en Wayland, p. ex. des de Brave)

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk 
    ];
    config.common.default = "*";
  };

  # dconf (necessari perquè el dconf.settings d'Home Manager, p. ex. el
  # tema d'icones, tingui efecte)

  programs.dconf.enable = true;
}
