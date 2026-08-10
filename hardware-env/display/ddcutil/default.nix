{ pkgs, ... }:
{
  # DDC/CI control (brightness, contrast, and any other VCP feature the
  # monitor firmware exposes) over the GPU's i2c bus, without touching the
  # monitor's physical buttons.
  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    ddcutil
    ddcui
  ];
}
