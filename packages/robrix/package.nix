{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:
appimageTools.wrapType2 rec {
  pname = "robrix";
  version = "v0.0.1-pre-alpha-4";

  src = fetchurl {
    url = "https://github.com/project-robius/robrix/releases/download/v0.0.1-pre-alpha-4/robrix_0.0.1-pre-alpha-4_x86_64.AppImage";
    hash = "sha256-blclfMCl7ddhJH1nC3C0qv2pHK1h83dk69gaonydJwg=";
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
    maintainers = with lib.maintainers; [  ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}