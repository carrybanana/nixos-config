# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # 系统基础设置（全局生效）
  # NVIDIA显卡驱动
  hardware.nvidia = {
    open = true;              # 启用开源 NVIDIA 内核模块
    nvidiaSettings = true;    # 安装 NVIDIA 控制面板
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;  # 硬件加速渲染（必须开）
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  programs.atop.atopgpu.enable = true;  # GPU 监控工具

  programs.gpu-screen-recorder.enable = true;  # NVIDIA 硬件加速录屏

  # 系统状态版本（保持原配置，首次安装后勿改）
  system.stateVersion = "26.05";

  # ✅ 安全、无红字、官方推荐的持久化配置
#   environment.persistence."/persist" = {
#     # 只持久化「安全、不与系统冲突」的目录
#     directories = [
#       "/etc/nixos"                  # 你的系统配置（核心，必须持久）
#       "/var/lib"                    # 系统服务数据
#       "/var/log"                    # 系统日志
#       "/var/cache"                  # 缓存（可选，持久化可加速）
#       "/srv"                        # 服务数据
#       "/var/tmp"                    # 临时文件
#       "/etc/NetworkManager/system-connections"  # Wi-Fi/网络配置
#     ];
#
#     # 只持久化「系统允许、无冲突」的文件
#     files = [
#       "/etc/machine-id"             # 系统唯一ID（必须持久）
#       "/etc/ssh/ssh_host_ed25519_key" # SSH密钥
#       "/etc/ssh/ssh_host_rsa_key"   # SSH密钥
#     ];
#   };
}

