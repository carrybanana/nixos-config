{ ... }:
{
  imports = [
    ./vaultwarden/default.nix # Vaultwarden 与 Caddy 纯内网自托管配置
    ./app-store.nix # flatpak  如意玲珑商店
    ./clash-verge.nix # Clash Verge 代理客户端
    ./immich.nix # immich相冊
    ./openssh.nix # SSH服务
    ./pipewire.nix # 音频服务
    ./soteria.nix # Soteria 安全增强模块
    ./udisks2.nix # 启用 UDisks2 磁盘管理服务（桌面环境必备）
  ];
}
