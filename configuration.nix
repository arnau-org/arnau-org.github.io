{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "ca_ES.UTF-8";
  console.keyMap = "ca";

  # Hyprland
  programs.hyprland.enable = true;
  programs.firefox.enable = true;
  programs.chromium.enable = true;
  #programs.chromium = {
  #enable = true;
  #package = pkgs.chromium; # o pkgs.brave, pkgs.google-chrome, etc.
  #extensions = [
  #  { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
  #  { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
  #];
  #commandLineArgs = [
  #  "--disable-features=AutofillSavePaymentMethods"
  #];
  #};   

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
  };

  fonts.packages = with pkgs; [ noto-fonts noto-fonts-color-emoji ];

  users.users.antoni = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    kitty
    bibata-cursors
  ];

  services.openssh.enable = true;

  system.stateVersion = "26.05"; # NO tocar mai
}
