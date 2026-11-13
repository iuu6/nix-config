{
  lib,
  stdenv,
  kernel,
  src,
  firmwarePath,
}:

stdenv.mkDerivation {
  pname = "aic8800";
  version = "${kernel.version}-unstable-2026-11-12";

  inherit src;

  # Kernel modules must not be built with -fPIC.
  hardeningDisable = [ "pic" ];

  # aic_load_fw reads firmware with filp_open() and hardcodes /lib/firmware.
  # NixOS has no /lib/firmware, and the copy in /run/current-system/firmware is
  # zstd-compressed, which filp_open() cannot read. Point the driver at the
  # uncompressed firmware tree instead.
  postPatch = ''
    substituteInPlace drivers/aic8800/aic_load_fw/aicbluetooth.c \
      --replace-fail '"/lib/firmware"' '"${firmwarePath}"'
  '';

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
