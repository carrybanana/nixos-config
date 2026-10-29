{ ... }:
{
  imports = [
    ./services/default.nix # 系统服务（安全、音频、SSH、代理等）
    ./boot.nix # 引导加载器 + 内核选择
    ./documentation.nix # man 手册等系统文档
    ./gpu.nix # GPU
    ./locale.nix # 时区、本地化/i18n
    ./networking.nix # 网络基础配置
    ./nix-config.nix # Nix 包管理器全局配置
    ./swap.nix # swap 与 zram 配置
    ./users.nix # 系统用户与权限
  ];
}
