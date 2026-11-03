{
  pkgs,
  ...
}:

{
  imports = [
    ./nixvim/default.nix
  ];

  environment.systemPackages = with pkgs; [
    # ==============================================
    # 系统基础工具
    # ==============================================
    nixos-rebuild-ng # 新一代 NixOS 系统重建工具，更简洁高效
    wget # 命令行下载工具，支持 HTTP/HTTPS/FTP
    git # 版本控制工具，代码管理必备
    tree # 以树形结构展示目录文件列表
    fastfetch # 系统信息展示工具（终端）
    unzip # 解压 zip 压缩包
    unrar # 解压 rar 压缩包
    _7zip-zstd # 解压 7z 压缩包
    cachix # Cachix 二进制缓存命令行客户端
    ffmpeg # 音视频转码/处理命令行工具
    libva # VA-API 视频硬件加速库
    libva-utils # VA-API 调试工具（vainfo 等）

    # ==============================================
    # 开发工具 & 终端编辑器
    # ==============================================
    micro-full # 终端文本编辑器（比 nano 更现代）
    tldr # 简化版 man，给常用命令示例
    eza # 现代 ls 替代品，彩色文件列表
    fd # 现代 find 替代品，快速文件查找
    bat # 带语法高亮的 cat 替代品
    helix # 现代化模态编辑器（终端内，轻量高效）
    pkg-config # 编译时头文件/库路径查询

    gcc # GNU C/C++ 编译器
    gdb # GNU 调试器
    cmake # 跨平台构建工具
    ninja # 高性能构建系统
    clang # LLVM 编译器前端（C/C++/Objective-C）
    clang-tools # clangd、clang-tidy、clang-format 等
    llvmPackages.libllvm
    llvmPackages.libcxx

    nil # Nix 语言 LSP 服务器（编辑器补全用）
    opencode # AI 编码助手（TUI）
    python3 # Python 解释器

    # ==============================================
    # 安卓设备管理（命令行）
    # ==============================================
    android-tools # 安卓调试工具集（adb/fastboot 等）
    usbutils # USB 设备管理工具（lsusb 等）

    # ==============================================
    # 系统监控（终端 TUI）
    # ==============================================
    btop-cuda # 带 CUDA 支持的系统资源监控器（CPU/GPU/内存）

    # ==============================================
    # 系统工具（图形）
    # ==============================================
    sirikali # 隐私保险箱（GUI，加密容器管理）
    localsend # 局域网文件传输（GUI）

    # ==============================================
    # 开发工具 & 编辑器（图形）
    # ==============================================
    qtcreator # Qt 集成开发环境
    kitty # 高性能 GPU 加速终端模拟器
    fuzzel # niri 默认的启动器
    alacritty # niri 默认的终端

    # ==============================================
    # 浏览器
    # ==============================================
    google-chrome # Google Chrome 浏览器

    # ==============================================
    # 桌面美化 & 窗口工具
    # ==============================================
    showmethekey # 屏幕实时显示按键输入（录屏/演示用）

    # ==============================================
    # 表格文档
    # ==============================================
    libreoffice-qt # LibreOffice（Qt 版）

    # ==============================================
    # 系统监控 & 硬件管理（图形）
    # ==============================================
    pwvucontrol # PipeWire 音频控制工具（GUI）
    coppwr # PipeWire 低延迟音频管理工具（GUI）

    # ==============================================
    # 密码安全
    # ==============================================
    bitwarden-desktop # Bitwarden 密码管理器（桌面版）
    kdePackages.keysmith # KDE 密钥/证书管理工具

    # ==============================================
    # 下载
    # ==============================================
    qbittorrent # qBittorrent BT 下载客户端

    # ==============================================
    # 学习 & 效率
    # ==============================================
    obsidian # Obsidian 笔记软件

    # ==============================================
    # 本地视频播放
    # ==============================================
    haruna # MPV 前端的视频播放器（KDE）

    # ==============================================
    # 快照工具
    # ==============================================
    btrfs-assistant
  ];

  # ======================
  # Shell: Zsh + Oh My Zsh
  # ======================
  programs.zsh = {
    enable = true;
    enableCompletion = true; # 启用原生命令补全
    enableBashCompletion = true; # 兼容 Bash 补全
    histSize = 20000; # 内存历史缓存条数

    # 命令自动建议（灰色提示）
    autosuggestions = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };

    # 实时语法高亮
    syntaxHighlighting.enable = true;

    # Oh My Zsh 核心配置
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

  # ======================
  # Qt 系统级配置
  # ======================
  qt.enable = true; # 系统级 Qt 主题、样式、插件支持

  # ======================
  # AppImage 直接运行支持
  # ======================
  programs.appimage = {
    enable = true;
    binfmt = true; # 直接双击运行 AppImage

    # 覆盖 appimage-run，添加缺失的库
    package = pkgs.appimage-run.override {
      extraPkgs =
        pkgs: with pkgs; [
          libepoxy # 刚刚报错缺失的库
          libxshmfence # 预防性添加，很多应用也需要
          libxshmfence
          libsoup_3
          webkitgtk_4_1
          libnotify
          libthai
        ];
    };
  };

  # ======================
  # nix-ld：运行预编译二进制（下载的 ELF、AppImage 等）
  # ======================
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # ========== 核心系统库 ==========
      stdenv.cc.cc
      zlib
      zstd
      curl
      openssl
      xz
      bzip2
      libxml2
      libsodium
      systemd
      util-linux
      attr
      acl

      # ========== 基础图形界面（预编译二进制可能依赖）==========
      glib
      gtk2
      gtk3
      pango
      cairo
      atk
      gdk-pixbuf
      fontconfig
      freetype
      expat
      dbus

      # ========== X11 窗口系统 ==========
      libx11
      libxext
      libxfixes
      libxrender
      libxcursor
      libxi
      libxrandr
      libxinerama
      libxtst
      libxcomposite
      libxdamage
      libxcb
      libxshmfence
      libxxf86vm

      # ========== 显卡 / 3D / 渲染 ==========
      libGL
      libGLU
      vulkan-loader
      libdrm
      libgbm
      libva
      libvdpau
      libepoxy

      # ========== 音频 ==========
      pipewire
      pulseaudio
      alsa-lib

      # ========== AppImage 必备 (fuse) ==========
      fuse
      e2fsprogs

      # ========== 游戏 / Steam / Unity ==========
      SDL2
      SDL2_mixer
      SDL2_ttf
      ffmpeg
      libunwind
      glew_1_10
      libogg
      libvorbis

      # ========== 网络 / 安全 ==========
      gnutls
      krb5
      brotli
      libcap

      # ========== 常用第三方软件依赖 ==========
      webkitgtk_4_1
      libsoup_3
      harfbuzz
      libnotify
      icu
      libarchive
      libxkbcommon # Blender
    ];
  };

  # ======================
  # Firefox
  # ======================
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
  };

  # ======================
  # OBS Studio（录屏/直播）
  # ======================
  programs.obs-studio = {
    enable = true;
  };

  # ======================
  # Steam 游戏平台
  # ======================
  programs.steam = {
    enable = true;
    fontPackages = with pkgs; [
      source-han-sans # 中文字体
    ];
  };

  # ======================
  # VSCode（图形编辑器）
  # ======================
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans # 中文语言包
      github.copilot-chat # GitHub Copilot Chat
    ];
  };
}
