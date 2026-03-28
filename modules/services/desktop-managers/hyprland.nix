{ config, lib, pkgs, inputs, ... }:

{
  # hyprland
  nix.settings = {
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    substituters = [
      "https://hyprland.cachix.org"
    ];
  };

  # 启用 Hyprland 系统级模块（核心：提供会话文件、依赖）
  programs.hyprland = {
    enable = true;
    # 使用 Flake 引入的 Hyprland 包（避免版本不一致）
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # 同步 xdg-desktop-portal-hyprland 版本（修复剪贴板/文件选择器问题）
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    # 身份验证代理
    hyprpolkitagent

    # 一款高性能 GPU 加速终端
    kitty

    # 设置和管理桌面壁纸，让界面更美观。
    hyprpaper
#    waypaper

    # 系统通知守护进程，负责接收和显示来自应用的通知（如消息提醒、系统提示）。
    mako
#    swaync
#    dunst

    # 必需，是 Wayland 桌面的核心接口，为应用提供文件选择、屏幕共享、权限管理等跨桌面环境的标准功能。
    xdg-desktop-portal-hyprland

    # 必需，系统状态栏 / 面板，显示时间、音量、网络、工作区、系统托盘等信息。
#    hyprlandPlugins.hyprbars

    # hyprland默认应用启动器
    hyprlauncher

    # 启用剪贴板管理
    wl-clipboard-rs

#    waybar
  ];
}
