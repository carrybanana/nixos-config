# /etc/nixos/modules/services/default.nix

{ config, lib, pkgs, ... }:

{
  # 导入级模块
  imports = [
    ./desktop-managers/default.nix
    ./display-managers/default.nix
  ];

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
  # services.v2raya.enable = true;
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
    interval = "daily";         # 直接设置执行频率（支持 "daily"、"weekly"、"monthly" 等）
  };

  # 5. 快照工具（Snapper，根分区快照）
  services.snapper = {
    configs = {
      root = {
        SUBVOLUME = "/";  # 正确：已改为大写
        TIMELINE_CREATE = true;   # 启用时间线快照
        TIMELINE_CLEANUP = true;  # 启用时间线快照清理
        NUMBER_LIMIT = "50";      # 保留50个快照（此选项为字符串类型，无需修改）
      };
    };
  };
}
