{
  lib,
  appimageTools,
  fetchurl,
  writeText,
  nix-update-script,
}:
let
  pname = "cogfly";
  version = "1.1.2";
  src = fetchurl {
    url = "https://github.com/Nix-main/Cogfly/releases/download/${version}/Cogfly-${version}.AppImage";
    hash = "sha256-oyUG3L4DoK8z79rnvsjwgFEoSo3rzQwvlg49lyeLCqg=";
  };
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/Nix-main/Cogfly/master/resources/icons/icon.png";
    hash = "sha256-nrgXKi7NC0KWcPUU1T47vKnnvpiBXpzsyegTGoN3Wbg=";
  };
  desktopItem = writeText "cogfly.desktop" ''
    [Desktop Entry]
    Name=Cogfly
    Exec=cogfly %u
    Icon=cogfly
    Type=Application
    Categories=Utility;
    MimeType=x-scheme-handler/cogfly;
  '';
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    libxext
    libxi
    libxrender
    libxtst
  ];

  extraInstallCommands = ''
    install -Dm444 ${icon} $out/share/icons/hicolor/256x256/apps/cogfly.png
    install -Dm444 ${desktopItem} $out/share/applications/cogfly.desktop
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform mod manager for Hollow Knight: Silksong";
    homepage = "https://github.com/Nix-main/Cogfly";
    license = lib.licenses.gpl3Only;
    mainProgram = "cogfly";
    maintainers = with lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
