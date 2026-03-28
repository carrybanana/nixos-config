{ config, lib, pkgs, ... }:

{
  # 导入级模块
  imports = [
    ./appimage.nix
    ./firefox.nix
    ./fish-shell.nix
    ./neovim.nix
    ./obs-studio.nix
    ./steam.nix
    ./vim.nix
    ./vscode.nix
    ./zsh.nix
  ];

  # 允许非自由软件（系统级，如NVIDIA驱动、Chrome）
  nixpkgs.config.allowUnfree = true;

  # 启用flatpak
  services.flatpak = {
    enable = true;
  };

  # 系统级软件（所有用户共享，如开发工具）
  environment.systemPackages = with pkgs; [
    nixos-rebuild-ng
    wget
    git
    tree        # 文件树
    fastfetch   # 系统信息展示

    # 开发软件
    gcc
    cmake
    ninja
    clang
    helix             #编辑器
    zed-editor-fhs    #编辑器
    jetbrains.clion

    nil  # 安装 nil LSP 服务器

    wechat      # 微信（系统级，避免多用户重复安装）
    qq
    xwayland-satellite 	# X11应用兼容，微信能启动

    qtscrcpy      # 手机投屏软件
    android-tools
    usbutils      # usb软件包

    kitty	  # 一款好用的终端
  ];
}
