{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation {
  pname = "aic8800";
  version = "${kernel.version}-unstable-2026-11-13";

  src = fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "2c2e67097016521f21c8916d1b914e21eb24e306";
    hash = "sha256-0R5trW6hf/JsU31ijlmEcuNraPVfenXzKqpkl1/aVxc=";
  };

  # Kernel modules must not be built with -fPIC.
  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.commonMakeFlags ++ [
    "-C"
    "drivers/aic8800"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.modDirVersion}"
  ];

  enableParallelBuilding = true;

  # The upstream install target writes to /lib/modules; install into $out
  # instead so that NixOS can merge the tree via aggregateModules.
  installPhase = ''
    runHook preInstall

    moddir="$out/lib/modules/${kernel.modDirVersion}/kernel"
    install -Dm644 drivers/aic8800/aic_load_fw/aic_load_fw.ko \
      "$moddir/drivers/net/wireless/aic8800/aic_load_fw.ko"
    install -Dm644 drivers/aic8800/aic8800_fdrv/aic8800_fdrv.ko \
      "$moddir/drivers/net/wireless/aic8800/aic8800_fdrv.ko"
    install -Dm644 drivers/aic8800/aic_zlp_quirk/aic_zlp_quirk.ko \
      "$moddir/drivers/bluetooth/aic_zlp_quirk.ko"

    runHook postInstall
  '';

  meta = {
    description = "AIC8800 Wi-Fi/Bluetooth driver (USB and SDIO)";
    homepage = "https://github.com/shenmintao/aic8800d80";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
