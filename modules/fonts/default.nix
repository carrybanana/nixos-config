{ config, lib, pkgs, ... }:

{
  # 中文字体配置（系统级字体，所有用户共享）
  fonts = {
    packages = with pkgs; [
      corefonts
      vista-fonts
      vista-fonts-chs
      vista-fonts-cht
      liberation_ttf

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      wqy_zenhei

      noto-fonts-color-emoji
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts

      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.space-mono
      nerd-fonts.droid-sans-mono
      nerd-fonts.code-new-roman
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.noto
      nerd-fonts.liberation
      nerd-fonts.hack

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
