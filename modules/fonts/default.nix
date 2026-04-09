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
      noto-fonts-color-emoji
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
    # 启用系统默认字体包（推荐开启）
    enableDefaultPackages = true;

    fontconfig = {
      # 启用字体配置（必须开，否则字体不生效）
      enable = true;

      # 设置系统三大类默认字体
      defaultFonts = {
        # 衬线字体（文章、书籍、网页正文）
        serif = ["Noto Serif" "Noto Serif CJK SC"];

        # 无衬线字体（系统界面、按钮、菜单、标题）
        sansSerif = ["Noto Sans"  "Noto Sans CJK SC"];

        # 等宽字体（终端、代码编辑器、终端模拟器）
        monospace = ["Fira Code"];
      };
    };
  };
}
