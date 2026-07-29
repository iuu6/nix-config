{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xournalpp
    cheese
    vlc
    obs-studio
    # 使用 Wayland 原生模式运行，避免 Xwayland+NVIDIA 花屏和光标闪烁
    (google-chrome.override {
      commandLineArgs = "--ozone-platform=wayland --enable-features=UseOzonePlatform --disable-features=UseChromeOSDirectVideoDecoder";
    })
    # electron-chromedriver # 已移除：依赖过期的 electron-38.8.4
  ];

  # 让 Electron 应用也原生运行在 Wayland 上
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
