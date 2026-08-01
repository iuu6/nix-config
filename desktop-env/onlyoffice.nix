{ config, pkgs, ... }:
{
  # OnlyOffice uses buildFHSEnv and only discovers fonts from targetPkgs at /usr/share/fonts.
  # Inject whatever fonts.packages has — no separate list to maintain.
  nixpkgs.overlays = [
    (final: prev: {
      onlyoffice-desktopeditors = prev.onlyoffice-desktopeditors.override {
        noto-fonts-cjk-sans = prev.symlinkJoin {
          name = "onlyoffice-cjk-fonts";
          paths = config.fonts.packages;
        };
      };
    })
  ];
}
