{ ... }:
{
  imports = [
    ./../../../desktop-env/gnome
    # 中文输入法：fcitx5（Rime / 拼音）。GNOME 模块已通过 desktop-env/default.nix
    # 间接引入，这里显式声明，保证输入法不会因上层模块调整而丢失。
    ./../../../desktop-env/common/fcitx5.nix
    ./../../../desktop-env/rustdesk
  ];
}
