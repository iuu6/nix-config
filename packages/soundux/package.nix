{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  gdk-pixbuf,
  webkitgtk_4_1,
  libappindicator-gtk3,
  libwnck,
  libx11,
  libxi,
  libxtst,
  openssl,
  zlib,
  brotli,
  pipewire,
  libpulseaudio,
  yt-dlp,
  ffmpeg,
  runCommand,
}:
let
  # Soundux shells out to the bare command name "youtube-dl" (not "yt-dlp"), and
  # upstream youtube-dl is largely dead against current YouTube, so alias yt-dlp.
  ytdlShim = runCommand "soundux-ytdl-shim" { } ''
    mkdir -p $out/bin
    ln -s ${lib.getExe yt-dlp} $out/bin/youtube-dl
  '';
in
stdenv.mkDerivation {
  pname = "soundux";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "Soundux";
    repo = "Soundux";
    rev = "0.2.7";
    fetchSubmodules = true;
    hash = "sha256-aSCsg6nJt6F+6O7UeXnvYva0vllTfsxK/cjaeOhObZY=";
  };

  postPatch = ''
    substituteInPlace src/ui/impl/webview/lib/webviewpp/CMakeLists.txt \
      --replace "webkit2gtk-4.0" "webkit2gtk-4.1" \
      --replace "-Wall -Wextra -Werror -pedantic -Wno-unused-lambda-capture" "-Wall -Wextra -pedantic"

    substituteInPlace lib/guardpp/CMakeLists.txt \
      --replace "-Wall -Werror -Wextra -pedantic" "-Wall -Wextra -pedantic"

    substituteInPlace lib/guardpp/guard/include/core/linux/guard.hpp \
      --replace "#include <core/guardbase.hpp>" "#include <core/guardbase.hpp>
#include <cstdint>"

    substituteInPlace src/helper/audio/linux/pipewire/pipewire.cpp \
      --replace "#include <memory>" "#include <algorithm>
#include <memory>" \
      --replace '            version = std::stoi(formattedVersion);
            if (version < 326)
            {
                Fancy::fancy.logTime().warning() << "Your PipeWire version is below the minimum required (0.3.26), "
                                                    "you may experience bugs or crashes"
                                                 << std::endl;
            }' '            version = std::stoi(formattedVersion);' \
      --replace '            if (!node.applicationBinary.empty() && !node.isMonitor)
            {
                bool hasInput = false;' '            if (!node.name.empty() && !node.isMonitor)
            {
                bool hasInput = false;' \
      --replace '            if (!node.applicationBinary.empty() && !node.isMonitor)
            {
                bool hasOutput = false;' '            if (!node.name.empty() && !node.isMonitor)
            {
                bool hasOutput = false;' \
      --replace '            //* Yes this is swapped. (For compatibility reasons)
            if (const auto *appName = spa_dict_lookup(info->props, "application.name"); appName)
            {
                self.applicationBinary = appName;
            }
            if (const auto *binary = spa_dict_lookup(info->props, "application.process.binary"); binary)
            {
                self.name = binary;
            }' '            //* Yes this is swapped. (For compatibility reasons)
            if (const auto *appName = spa_dict_lookup(info->props, "application.name"); appName)
            {
                self.applicationBinary = appName;
            }
            else if (const auto *nodeDesc = spa_dict_lookup(info->props, "node.description"); nodeDesc)
            {
                //* Clients such as OpenAL/SDL streams (e.g. Telegram calls) never set application.name.
                self.applicationBinary = nodeDesc;
            }
            if (const auto *binary = spa_dict_lookup(info->props, "application.process.binary"); binary)
            {
                self.name = binary;
            }
            else if (const auto *nodeName = spa_dict_lookup(info->props, "node.name"); nodeName)
            {
                self.name = nodeName;
            }'

    substituteInPlace CMakeLists.txt \
      --replace 'set(CMAKE_INSTALL_PREFIX "/opt/soundux" CACHE PATH "Install path prefix, prepended onto install directories." FORCE)' "" \
      --replace 'install(TARGETS soundux DESTINATION .)' 'install(TARGETS soundux DESTINATION bin)' \
      --replace 'install(DIRECTORY "''${CMAKE_SOURCE_DIR}/build/dist" DESTINATION .)' 'install(DIRECTORY "''${CMAKE_SOURCE_DIR}/build/dist" DESTINATION bin)' \
      --replace "DESTINATION /usr/share/applications" "DESTINATION share/applications" \
      --replace "DESTINATION /usr/share/metainfo" "DESTINATION share/metainfo" \
      --replace "DESTINATION /usr/share/pixmaps" "DESTINATION share/pixmaps"

    substituteInPlace deployment/soundux.desktop \
      --replace "/opt/soundux/soundux" "soundux"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    gdk-pixbuf
    webkitgtk_4_1
    libappindicator-gtk3
    libwnck
    libx11
    libxi
    libxtst
    openssl
    zlib
    brotli
    pipewire
    libpulseaudio
  ];

  cmakeBuildType = "Release";

  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];

  # Soundux dlopen()s libpipewire/libpulse by bare soname at runtime instead of
  # linking them, which only resolves on FHS distros where those libs live in
  # /usr/lib. Point LD_LIBRARY_PATH at their Nix store paths so dlopen finds them.
  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pipewire libpulseaudio libwnck ]}")
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ ytdlShim ffmpeg ]}")
  '';

  meta = {
    description = "Cross-platform soundboard for playing audio into specific applications or virtual audio sinks";
    homepage = "https://github.com/Soundux/Soundux";
    license = lib.licenses.gpl3Only;
    mainProgram = "soundux";
    platforms = [ "x86_64-linux" ];
  };
}
