{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # Cantarell
      cantarell-fonts
      # Noto Fonts
      noto-fonts
      noto-fonts-color-emoji
      # 思源宋体/思源黑体 (CJK Fonts)
      # Variable-fonts may cause some apps to not render CJK correctly
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-mono
      source-han-sans
      source-han-serif
      fira-code
      fira-code-symbols
      jetbrains-mono
      source-code-pro
      sarasa-gothic
    ];
    # 设置 fontconfig 防止出现乱码
    fontconfig = {
      defaultFonts = {
        emoji = [
          "Noto Color Emoji"
        ];
        monospace = [
          # Main Mono Font
          "JetBrainsMono"
          # CJK Fallback
          "Noto Mono SC"
          "Noto Mono TC"
          "Noto Mono JP"
          "Noto Mono KR"
          # Unicode Fallback
          "DejaVu Sans Mono"
          #"Noto Sans Mono CJK SC"
          #"Sarasa Mono SC"
          #"DejaVu Sans Mono"
        ];
        sansSerif = [
          # Main Sans-Serif Font
          "Cantarell"
          # CJK Fallback
          "Noto Sans SC"
          "Noto Sans TC"
          "Noto Sans JP"
          "Noto Sans KR"
          # Unicode Fallback
          "DejaVu Sans"
          #"Noto Sans CJK SC"
          #"Source Han Sans SC"
          #"DejaVu Sans"
        ];
        serif = [
          # Main Serif Font
          "Noto Serif"
          # CJK Fallback
          "Noto Serif SC"
          "Noto Serif TC"
          "Noto Serif JP"
          "Noto Serif KR"
          # Unicode Fallback
          "DejaVu Serif"
          #"Noto Serif CJK SC"
          #"Source Han Serif SC"
          #"DejaVu Serif"
        ];
      };
    };
  };
}
