# /etc/nixos/modules/system/default.nix

{ config, lib, pkgs, ... }:

{
  imports = [
    ./programs/default.nix  # 相对路径导入
  ];

  # 引导加载器配置
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
      efi = {
        canTouchEfiVariables = true;  # 允许修改EFI变量，支持UEFI引导
        efiSysMountPoint = "/boot";
      };
    };
  };

  # 内核配置（最新内核）
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # 启用硬件支持，特别是固件（firmware）和 CPU 微码（microcode）更新，以确保系统稳定、安全并能正确驱动硬件设备。
  hardware = {
    enableAllFirmware = true; # 自动安装所有固件
    cpu.intel.updateMicrocode = true; # Intel CPU
    # cpu.amd.updateMicrocode = true; # AMD CPU
  };
  # 开启图形加速支持,32位应用支持
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs;[
      nvidia-vaapi-driver
      libva
      libva-utils
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
    ];
  };

  # 3. 启用 Soteria 安全增强模块
  security.soteria.enable = true;

  # 启用 UDisks2 磁盘管理服务（桌面环境必备）
  services.udisks2.enable = true;

  # 网络基础配置
  networking = {
    hostName = "nixos";     # 设置主机名
    networkmanager.enable = true;  # 图形化网络管理,启用NetworkManager，支持无线网络管理
  };

#   # 系统级代理设置
#   networking.proxy = {
#     default = "http://127.0.0.1:7897";
#     httpProxy = "http://127.0.0.1:7897";
#     httpsProxy = "http://127.0.0.1:7897";
#     noProxy = "localhost,127.0.0.1,::1,*.local";
#   };

  # 时区与本地化（中文环境）
  time.timeZone = "Asia/Shanghai";   # 设置时区为上海（中国标准时间）
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };


  # 仅保留「系统级用户配置」（用户创建、组权限，用户专属配置放home/）
  users.users.carry = {
    isNormalUser = true;
    description = "carry";
    home = "/home/carry";
    hashedPassword = "$6$SVz6B.Fb2meBkDtX$2ntIrV66eLVEnrLDW0yFGfcnEjt1.PGRvM/8Zkp87OPRzwwZ5evHWfBTvPaMwtiG/ImE9HJ0nZxoA4ewpc3/n0";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "kvm" "libvirtd" ];  # 网络管理+sudo权限
    uid = 1000;  # 可选：固定UID，避免多设备同步冲突
  };

  # 固化 /etc/nixos 权限：所有者=carry，组=users（你的实际默认组）
  # 权限 0755 安全可控，不影响 git 操作和系统安全性
  systemd.tmpfiles.rules = [
    "d /etc/nixos 0755 carry users - -"
  ];

  # 启用系统文档功能，特别是 man 手册（manual pages）并优化其使用体验。
  documentation = {
    enable = true;
    man = {
      cache.enable = true;
      man-db = {
        enable = true;
      };
    };
  };

  # Catppuccin 主题
  catppuccin = {
    enable = true;
    autoEnable = true; # 和enable保持一致即可消除警告
  };

}
