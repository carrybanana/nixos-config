{ config, lib, pkgs, ... }:

{
  # 中文字体配置（系统级字体，所有用户共享）
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans   # 思源黑体
      noto-fonts-cjk-serif  # 思源宋体
      noto-fonts-color-emoji

      # jetbrains-mono
      # nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
        monospace = [ "JetBrains Mono Nerd Font" ];
      };
    };
  };
}
