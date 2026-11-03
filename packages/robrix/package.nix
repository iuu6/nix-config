{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:
appimageTools.wrapType2 rec {
  pname = "robrix";
  version = "v1.0.0-beta.5";

  src = fetchurl {
    url = "https://github.com/project-robius/robrix/releases/download/${version}/robrix-${lib.removePrefix "v" version}-x86_64.AppImage";
    hash = "sha256-CPuyxVV/6zTedGTnvdDVPDvPvgDTSUSe0h594pExOrI=";
  };

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      install -Dm444 ${appimageContents}/robrix.desktop -t $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Robrix: a Rust Matrix client built atop Robius";
    homepage = "https://github.com/project-robius/robrix";
    license = lib.licenses.mit;
    mainProgram = "robrix";
    maintainers = with lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
