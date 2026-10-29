{
  ...
}:

{
  # ==========================================
  # Vaultwarden 与 Caddy 纯内网自托管配置
  # ==========================================

  # 1. 启用 Vaultwarden
  services.vaultwarden = {
    enable = true;
    # 指向 Caddy 代理的内网 HTTPS 地址
    domain = "https://192.168.1.215:8443";
    # 备份目录（建议后续把这里加入你的备份计划）
    backupDir = "/var/backup/vaultwarden";

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

  # 让系统信任这个本地 CA 证书
  security.pki.certificateFiles = [ ./vaultwarden-ca.crt ];
}
