{
  pkgs,
  ...
}:

{
  # 3. 启用 Soteria 安全增强模块
  security.soteria.enable = true;

  # 启用 UDisks2 磁盘管理服务（桌面环境必备）
  services.udisks2.enable = true;

  # 1. 音频服务（PipeWire替代PulseAudio）
  services.pulseaudio.enable = false; # 禁用旧的 PulseAudio 服务
  security.rtkit.enable = true; # 启用实时线程调度（低延迟音频必备）
  services.pipewire = {
    enable = true; # 核心：启用 PipeWire 主服务
    alsa.enable = true; # 兼容 ALSA 音频架构（Linux 基础音频）
    alsa.support32Bit = true; # 支持 32 位应用的 ALSA 兼容（如 Wine/游戏）
    pulse.enable = true; # 兼容 PulseAudio 协议（绝大多数桌面软件依赖）
    jack.enable = true; # 启用 JACK 兼容（专业音频软件/DAW 必备）
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

  # 启用flatpak
  services.flatpak = {
    enable = true;
  };

  # 如意玲珑商店
  services.linyaps = {
    enable = true;
  };

  # 已开启`discard=async` Btrfs 异步 TRIM，所以关闭 strim.timer（传统定时修剪）
  #   # 4. 磁盘优化（fstrim，SSD必备）
  #   services.fstrim = {
  #     enable = true;
  #     interval = "weekly";         # 直接设置执行频率（支持 "daily"、"weekly"、"monthly" 等）
  #   };

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



  # ==========================================
  # Immich 纯内网自托管配置
  # ==========================================
  # 1. 启用NVIDIA容器工具包 (必须，让容器能访问GPU)
  hardware.nvidia-container-toolkit.enable = true;

  # 2. Immich服务配置
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";
    openFirewall = true;
    machine-learning.enable = true;

    # 3. 告诉Immich的机器学习服务使用CUDA
    environment = {
      MACHINE_LEARNING_DEVICE = "cuda";
    };
  };



  # ==========================================
  # Vaultwarden 与 Caddy 纯内网自托管配置
  # ==========================================

  # 1. 启用 Vaultwarden
  services.vaultwarden = {
    enable = true;
    # 指向 Caddy 代理的内网 HTTPS 地址
    domain = "https://192.168.1.215:8443";
    # 备份目录（建议后续把这里加入你的备份计划）
    backupDir = "/var/lib/vaultwarden/backup";

    config = {
      # 仅监听本地回环，由 Caddy 负责对外通信
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      # 初次部署设为 true 以便注册管理员，注册完立刻改回 false
      SIGNUPS_ALLOWED = true;
    };
  };

  # 2. 配置 Caddy 反向代理与内部 HTTPS
  services.caddy = {
    enable = true;
    virtualHosts."https://192.168.1.215:8443" = {
      extraConfig = ''
        # 实时通知 (WebSocket) 转发，用于多设备即时同步
        reverse_proxy /notifications/hub* localhost:3012

        # 其余所有请求转发给 Vaultwarden
        reverse_proxy localhost:8222

        # 使用 Caddy 的内部 CA 自动签发本地证书
        tls internal
      '';
    };
  };

  # 3. 防火墙仅放行 Caddy 的 HTTPS 端口，Vaultwarden 的 8222 端口不对外
  networking.firewall.allowedTCPPorts = [ 8443 ];
}
