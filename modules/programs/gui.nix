{
  pkgs,
  ...
}:

{
  # ==========================================================================
  # GUI 工具集：需要图形会话（X11 / Wayland）才能用
  # ==========================================================================
  environment.systemPackages = with pkgs; [
    # ==============================================
    # 系统工具（图形）
    # ==============================================
    sirikali # 隐私保险箱（GUI，加密容器管理）
    localsend # 局域网文件传输（GUI）

    # ==============================================
    # 开发工具 & 编辑器（图形）
    # ==============================================
    zed-editor-fhs # Zed 编辑器（FHS 兼容版）
    jetbrains-toolbox # JetBrains 全家桶管理工具
    qtcreator # Qt 集成开发环境
    kitty # 高性能 GPU 加速终端模拟器
    fuzzel # niri 默认的启动器
    alacritty # niri 默认的终端

    # ==============================================
    # 安卓设备管理（图形）
    # ==============================================
    qtscrcpy # 图形化手机投屏 + 控制工具（基于 scrcpy）

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
    onlyoffice-desktopeditors # OnlyOffice 桌面套件
    libreoffice-qt # LibreOffice（Qt 版）

    # ==============================================
    # 系统监控 & 硬件管理（图形）
    # ==============================================
    pwvucontrol # PipeWire 音频控制工具（GUI）
    coppwr # PipeWire 低延迟音频管理工具（GUI）

    # ==============================================
    # 远程桌面
    # ==============================================
    rustdesk-flutter # RustDesk 远程桌面客户端

    # ==============================================
    # 密码安全
    # ==============================================
    bitwarden-desktop # Bitwarden 密码管理器（桌面版）
    kdePackages.keysmith # KDE 密钥/证书管理工具
    keepassxc # KeePassXC 密码管理器

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
  ];

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
  # Firefox（GUI 浏览器）
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
