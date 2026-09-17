{ config, lib, pkgs, ... }:

{
  # Gestor de pantalla (SDDM en Wayland, sense Xorg)

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.displayManager.defaultSession = "hyprland";

  # Polkit (necessari per a diàlegs d'autenticació gràfics: muntar USB,
  # gestionar xarxa des de la GUI, etc.)

  security.polkit.enable = true;

  # Portal XDG (captura/compartició de pantalla en Wayland, p. ex. des de Brave)

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  # dconf (necessari perquè el dconf.settings d'Home Manager, p. ex. el
  # tema d'icones, tingui efecte)

  programs.dconf.enable = true;
}
