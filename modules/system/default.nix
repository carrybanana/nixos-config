# /etc/nixos/modules/system/default.nix

{ config, lib, pkgs, ... }:

{
  # 引导加载器配置
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;

        extraEntries = ''
  menuentry "CachyOS (nvme2n1 Limine)" --class gnu-linux --class os {
    insmod part_gpt
    insmod fat
    insmod chain
    search --no-floppy --fs-uuid --set=root C372-FAC2
    chainloader /EFI/limine/limine_x64.efi
  }
  '';
      };
      efi = {
        canTouchEfiVariables = true;  # 允许修改EFI变量，支持UEFI引导
        efiSysMountPoint = "/boot";
      };
    };
  };

  # 内核配置（最新内核）
#   boot.kernelPackages = pkgs.linuxPackages_latest;

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

#   # 固化 /etc/nixos 权限：所有者=carry，组=users（你的实际默认组）
#   # 权限 0755 安全可控，不影响 git 操作和系统安全性
#   systemd.tmpfiles.rules = [
#     "d /etc/nixos 0755 carry users - -"
#   ];

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

    # 1. 音频服务（PipeWire替代PulseAudio）
  services.pulseaudio.enable = false;        # 禁用旧的 PulseAudio 服务
  security.rtkit.enable = true;              # 启用实时线程调度（低延迟音频必备）
  services.pipewire = {
    enable = true;                            # 核心：启用 PipeWire 主服务
    alsa.enable = true;                       # 兼容 ALSA 音频架构（Linux 基础音频）
    alsa.support32Bit = true;                 # 支持 32 位应用的 ALSA 兼容（如 Wine/游戏）
    pulse.enable = true;                      # 兼容 PulseAudio 协议（绝大多数桌面软件依赖）
    jack.enable = true;                       # 启用 JACK 兼容（专业音频软件/DAW 必备）
  };


  # 2. SSH服务（远程登录）
  services.openssh.enable = true;
  # 可选：防火墙开放SSH端口（如需远程访问）
  # networking.firewall.allowedTCPPorts = [ 22 ];

  # 3. V2RayA代理服务
  services.v2raya.enable = true;
  # 可选：防火墙开放V2RayA端口（如1080）
  # networking.firewall.allowedTCPPorts = [ 1080 ];

  # Clash Verge 代理客户端
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    group = "wheel";
    tunMode = true;
    serviceMode = true;
  };

  # 4. 磁盘优化（fstrim，SSD必备）
  services.fstrim = {
    enable = true;
    interval = "weekly";         # 直接设置执行频率（支持 "daily"、"weekly"、"monthly" 等）
  };

#   # 5. 快照工具（Snapper，根分区快照）
#   services.snapper = {
#     configs = {
#       root = {
#         SUBVOLUME = "/";  # 正确：已改为大写
#         TIMELINE_CREATE = true;   # 启用时间线快照
#         TIMELINE_CLEANUP = true;  # 启用时间线快照清理
#         NUMBER_LIMIT = "50";      # 保留50个快照（此选项为字符串类型，无需修改）
#       };
#     };
#   };

  # 全局 Nix 镜像配置（已加入：清华+中科大+官方）
  nix = {
    settings = {
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" # 清华
        "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大
        "https://cache.nixos.org/"  # 官方兜底
        "https://nix-community.cachix.org"
      ];
      # 仅保留官方公钥（清华/中科大无独立公钥）
      trusted-public-keys = [
        "mirrors.tuna.tsinghua.edu.cn-1:4YeXhlzW0NlzcqF9000LL5z0nQjN1L3QkA4Uvb01Xo0=" # 清华源公钥
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="  # 官方源的公钥
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # nix-community公钥
      ];
      trusted-users = [ "root" "carry" ]; # 添加可信用户
      experimental-features = [ "nix-command" "flakes" ]; # 启用实验性功能：nix命令增强和flakes支持
      auto-optimise-store = true;
      sandbox = true;
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      download-buffer-size = 128M
    '';

    gc = {
      automatic = true;
      dates = "Mon *-*-* 01:00:00";
      options = "--delete-older-than 30d";
      persistent = true;
      randomizedDelaySec = "30min";
    };
  };
}
