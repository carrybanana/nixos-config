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
    ./vscode.nix
    ./zsh.nix
  ];

  # 启用flatpak
  services.flatpak = {
    enable = true;
  };

  # 如意玲珑商店
#   services.linyaps = {
#     enable = true;
#   };

  # 系统级软件（所有用户共享，如开发工具）
  environment.systemPackages = with pkgs; [
    # ==============================================
    # 系统基础工具
    # ==============================================
    nixos-rebuild-ng      # 新一代NixOS系统重建工具，更简洁高效
    wget                  # 命令行下载工具，支持HTTP/HTTPS/FTP下载
    git                   # 版本控制工具，代码管理必备
    tree                  # 以树形结构展示目录文件列表
    fastfetch             # 系统信息展示工具
    unzip                 # 解压zip压缩包
    unrar                 # 解压rar压缩包

    cachix
    ffmpeg
    libva
    libva-utils

    # ==============================================
    # 开发工具 & 编辑器
    # ==============================================
    micro-full
    tldr
    eza
    fd
    bat
    helix                 # 现代化模态编辑器（轻量高效）
    zed-editor-fhs        # Zed编辑器（FHS兼容版）
    jetbrains-toolbox     # JetBrains 管理工具
    qtcreator
    gcc
    gdb
    cmake                 # 跨平台构建工具
    ninja                 # 高性能构建系统
    pkg-config
    clang                 # LLVM编译器前端（C/C++/Objective-C）
    clang-tools           # 包含 clangd、clang-tidy、clang-format 等所有工具
    nil                   # Nix语言LSP服务器（代码补全/提示）
    kitty                 # 高性能GPU加速终端模拟器
    fuzzel                # niri默认的启动器
    alacritty	          # niri默认的终端
    opencode
    python3

    # ==============================================
    # 日常社交 / 通讯
    # ==============================================
    wechat           # 微信（系统级安装，全局可用）
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
    libreoffice-qt

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

    # 密码安全
#     bitwarden-desktop
    kdePackages.keysmith
    keepassxc

    # 下载
    qbittorrent

    # 学习 & 效率
#     ticktick
#     notion-app
    obsidian

    # 本地视频播放
    haruna
  ];

  # 系统级 Qt 整体配置、主题样式、插件支持
  qt.enable = true;

  # 启用 AppImage 直接运行支持
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # 系统级应用启用 Firefox
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
  };

    # 启用Fish Shell
  programs.fish = {
    enable = true;
  };

  # ======================
  # Neovim 主配置
  # ======================
  programs.neovim = {
      enable = true;        # 启用 NixVim
#     vimAlias = true;      # 输入 vim → 自动打开 nvim
#     viAlias = true;       # 输入 vi → 自动打开 nvim
    defaultEditor = false;# 不设为系统默认编辑器
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
        # ========== 核心系统库 ==========
        stdenv.cc.cc zlib zstd curl openssl xz bzip2
        libxml2 libsodium systemd util-linux attr acl

        # ========== 基础图形界面 (所有桌面软件通用) ==========
        glib gtk2 gtk3 pango cairo atk gdk-pixbuf
        fontconfig freetype expat dbus

        # ========== X11 窗口系统 ==========
        libx11 libxext libxfixes libxrender libxcursor libxi
        libxrandr libxinerama libxtst libxcomposite libxdamage
        libxcb libxshmfence libxxf86vm

        # ========== 显卡 / 3D / 渲染 ==========
        libGL libGLU vulkan-loader libdrm libgbm libva libvdpau
        libepoxy

        # ========== 音频 ==========
        pipewire pulseaudio alsa-lib

        # ========== AppImage 必备 (fuse) ==========
        fuse e2fsprogs

        # ========== 游戏 / Steam / Unity ==========
        SDL2 SDL2_mixer SDL2_ttf ffmpeg libunwind
        glew_1_10 libogg libvorbis

        # ========== 网络 / 安全 ==========
        gnutls krb5 brotli libcap

        # ========== 常用第三方软件依赖 ==========
        webkitgtk_4_1 libsoup_3 harfbuzz
        libnotify icu libarchive
        libxkbcommon # Blender
    ];
  };

  # 录制软件
  programs.obs-studio = {
    enable = true;
  };

  # Steam游戏平台
  programs.steam = {
    enable = true;
    fontPackages = with pkgs; [
      source-han-sans
    ];
  };

  # vscode
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans  # 中文语言包
      github.copilot-chat
    ];
  };

    # === Shell: Zsh + Oh My Zsh 合并增强版 ===
  programs.zsh = {
    enable = true;
    enableCompletion = true;           # 启用原生命令补全
    enableBashCompletion = true;       # 兼容 Bash 补全
    histSize = 20000;                  # 内存缓存

    # 命令自动建议（灰色提示）
    autosuggestions = {
      enable = true;
      strategy = [ "history" "completion" ];
    };

    # 实时语法高亮
    syntaxHighlighting.enable = true;

    # Oh My Zsh 核心配置（保留你喜欢的主题 + 插件）
    ohMyZsh = {
      enable = true;
      theme = "gnzh";
      plugins = [
        "git"
        "docker"
        "kubectl"
        "sudo"
        "extract"
        "history"
        "colorize"
        "command-not-found"
        "colored-man-pages"
        "fancy-ctrl-z"
      ];
    };
  };
  # 将默认 Shell 设置为 zsh
  users.users.carry.shell = pkgs.zsh;
}
