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
  system.stateVersion = "25.05";
}

