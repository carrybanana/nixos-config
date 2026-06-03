{ config, lib, pkgs, ... }:

{
  # 中文字体配置（系统级字体，所有用户共享）
  fonts = {
    packages = with pkgs; [
      # 微软核心字体（兼容网页/文档）
      corefonts
      liberation_ttf

      # 官方权威中文字体（系统界面/中文渲染全覆盖）
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      noto-fonts-cjk-serif

      # --------------------------
      # Maple Mono 字体套装（Wayland/高分屏首选 unhinted 版本）
      # 编辑器专用：纯代码等宽字体，无图标，更清爽
      maple-mono.truetype
      # 终端专用：带 Nerd Font 图标，适配命令行工具
      maple-mono.NF-unhinted
      # 终端中日文专用：带图标 + 完整中文/日文支持（全局默认等宽字体）
      maple-mono.NF-CN-unhinted
      # --------------------------

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

        # --------------------------
        # 等宽字体（终端/代码编辑器全局默认）
        # 优先级：中文+图标版 → 纯代码版，完美覆盖所有场景
        # --------------------------
        monospace = [
          "Maple Mono NF CN"
          "Maple Mono"
        ];
      };
    };
  };
}
