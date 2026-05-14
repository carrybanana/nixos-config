{ config, lib, pkgs, ... }:

{
  # 导入级模块
  imports = [
    ./appimage.nix
    ./firefox.nix
    ./fish-shell.nix
    ./neovim.nix
    ./nix-ld.nix
    ./obs-studio.nix
    ./steam.nix
    ./vim.nix
    ./vscode.nix
    ./zsh.nix
  ];

  # 启用flatpak
  services.flatpak = {
    enable = true;
  };

  # 如意玲珑商店
  services.linyaps = {
    enable = true;
  };

  # 系统级软件（所有用户共享，如开发工具）
  environment.systemPackages = with pkgs; [
    # ==============================================
    # 系统基础工具
    # ==============================================
    nixos-rebuild-ng     # 新一代NixOS系统重建工具，更简洁高效
    wget                 # 命令行下载工具，支持HTTP/HTTPS/FTP下载
    git                  # 版本控制工具，代码管理必备
    tree                 # 以树形结构展示目录文件列表
    fastfetch            # 系统信息展示工具
    unzip                # 解压zip压缩包
    unrar                # 解压rar压缩包

    cachix
    ffmpeg
    libva
    libva-utils

    # ==============================================
    # 开发工具 & 编辑器
    # ==============================================
    helix                # 现代化模态编辑器（轻量高效）
    zed-editor-fhs       # Zed编辑器（FHS兼容版）
    jetbrains-toolbox    # JetBrains 管理工具
    gcc                  # GNU C/C++ 编译器
    cmake                # 跨平台构建工具
    ninja                # 高性能构建系统
    clang                # LLVM编译器前端（C/C++/Objective-C）
    clang-tools          # 包含 clangd、clang-tidy、clang-format 等所有工具
    nil                  # Nix语言LSP服务器（代码补全/提示）
    kitty                # 高性能GPU加速终端模拟器

    # ==============================================
    # 日常社交 / 通讯
    # ==============================================
    wechat                # 微信（系统级安装，全局可用）
    qq                    # QQ 即时通讯工具
    xwayland-satellite    # X11应用兼容层，解决微信/QQ启动依赖

    # ==============================================
    # 安卓设备 / 手机管理
    # ==============================================
    qtscrcpy              # 图形化手机投屏+控制工具（基于scrcpy）
    android-tools         # 安卓调试工具集（adb/fastboot等）
    usbutils              # USB设备管理工具（lsusb等）

    # ==============================================
    # 浏览器
    # ==============================================
    google-chrome         # Google Chrome 浏览器

    # ==============================================
    # 桌面美化 & 窗口工具
    # ==============================================
    showmethekey         # 屏幕实时显示按键输入（录屏/演示用）

    # ==============================================
    # 表格文档
    # ==============================================
    onlyoffice-desktopeditors

    # ==============================================
    # 系统监控 & 硬件管理
    # ==============================================
    btop-cuda            # 带CUDA支持的系统资源监控器（CPU/GPU/内存）
    pwvucontrol          # PipeWire音频控制工具
    coppwr               # PipeWire低延迟音频管理工具

    # ==============================================
    # 远程桌面
    # ==============================================
    rustdesk-flutter

    proton-vpn
  ];
}
