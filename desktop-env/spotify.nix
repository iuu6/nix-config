{ pkgs, ... }:
{
  # Force Spotify to run via XWayland instead of native Wayland.
  # In native Wayland mode, Spotify reads the system accent color via XDG portal
  # and paints its own title bar in that color (blue by default on GNOME).
  # On XWayland, Spotify's Chromium renders a frameless dark window itself.
  nixpkgs.overlays = [
    (self: super: {
      spotify = super.spotify.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ super.makeWrapper ];
        postFixup = (old.postFixup or "") + ''
          wrapProgram $out/bin/spotify --unset NIXOS_OZONE_WL
        '';
      });
    })
  ];

  environment.systemPackages = with pkgs; [ spotify ];
}
