{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./brave.nix
    ./desktop.nix
    ./fonts.nix
  ];

  # Arrencada

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Xarxa

  networking.hostName = "argos";
  networking.networkmanager.enable = true;

  # Zona horària i locale

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

  # Nix

  boot.kernelPackages = pkgs.linuxPackages_latest;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "cat";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Àudio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Acceleració de vídeo (Intel HD 530 - Skylake)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  # Hyprland

  # UWSM desactivat per evitar problemes coneguts amb SDDM a la 26.05.
  # Si vols fer servir UWSM per iniciar Hyprland manualment des del TTY,
  # posa `withUWSM = true;` i inicia la sessió amb:
  #   uwsm start hyprland-uwsm.desktop
  programs.hyprland = {
    enable = true;
    withUWSM = false;
  };

  # Manteniment del disc (SSD)

  services.fstrim.enable = true;

  # Swap comprimida en RAM — marge barat amb només 12 GB

  zramSwap.enable = true;

  # Home Manager

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [
      inputs.caelestia-shell.homeModules.default
    ];
    users = {
      antoni = import ./home.nix;
    };
  };

  # Usuari

  users.users.antoni = {
    isNormalUser = true;
    description = "Antoni";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "audio"
    ];
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

  # Paquets del sistema

  environment.systemPackages = with pkgs; [
    curl
    git
    wget
    wireguard-tools
  ];

  # Neteja automàtica de l'store

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Serveis a habilitar

  services.openssh.enable = true;
  services.gvfs.enable = true;

  # Versió d'estat

  system.stateVersion = "26.05";
}
