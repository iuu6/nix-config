{ pkgs, ... }:
{
  # Fix ProtonPlus 0.5.19 downloading AArch64 GE-Proton on x86_64.
  # GloriousEggroll added aarch64 assets to releases, shifting x86_64 .tar.gz
  # from asset index 1 to index 3. ProtonPlus still hardcodes index 1.
  nixpkgs.overlays = [
    (self: super: {
      protonplus = super.protonplus.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          sed -i '/GloriousEggroll\/proton-ge-custom\/releases/{n;s/"asset_position": 1/"asset_position": 3/}' data/runners.json
        '';
      });
    })
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    wine
    protontricks
    protonplus
  ];
}
