# Configuració inicial NixOS

{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Nix (per habilitar flakes després)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Xarxa
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Localització
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "ca_ES.UTF-8";
    i18n.extraLocaleSettings = {
    LC_ADDRESS = "ca_ES.UTF-8";
    LC_IDENTIFICATION = "ca_ES.UTF-8";
    LC_MEASUREMENT = "ca_ES.UTF-8";
    LC_MONETARY = "ca_ES.UTF-8";
    LC_NAME = "ca_ES.UTF-8";
    LC_NUMERIC = "ca_ES.UTF-8";
    LC_PAPER = "ca_ES.UTF-8";
    LC_TELEPHONE = "ca_ES.UTF-8";
    LC_TIME = "ca_ES.UTF-8";
  };
  console.keyMap = "es";

  # Àudio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Usuari
  users.users.antoni = {
    isNormalUser = true;
    initialPassword = "antoni";
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };

  security.sudo.extraRules = [
    {
      users = [ "antoni" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Eines bàsiques
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  services.openssh.enable = true;

  system.stateVersion = "26.05"; # NO tocar mai
}
