# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # 系统基础设置（全局生效）
  # NVIDIA显卡驱动
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;  # 启用Wayland硬件加速
    # powerManagement.enable = true;  # 电源管理（笔记本必备）
    # powerManagement.finegrained = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # 系统状态版本（保持原配置，首次安装后勿改）
  system.stateVersion = "25.05";

  # 3. 可选：备份系统配置（防止误删）
  # system.copySystemConfiguration = true;
}

