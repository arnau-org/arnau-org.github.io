{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brave
  ];

  programs.chromium = {
    enable = true;

    extraOpts = {

      BraveRewardsDisabled        = true;
      BraveWalletDisabled         = true;
      BraveVPNDisabled            = true;
      BraveAIChatEnabled          = false;   # Leo AI
      BraveNewsDisabled           = true;
      BraveTalkDisabled           = true;
      BravePlaylistEnabled        = false;
      BraveWaybackMachineEnabled  = false;

      BraveP3AEnabled             = false;
      BraveStatsPingEnabled       = false;
      BraveWebDiscoveryEnabled    = false;
      PasswordManagerEnabled      = false;
      AutofillCreditCardEnabled   = false;

      DnsOverHttpsMode            = "secure";

      BraveShieldsTrackersBlocked = true;
      BraveShieldsHttpsEverywhere = true;

      TorDisabled                 = true;
    };
  };
}
