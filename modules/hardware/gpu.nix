{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ]; # 开启nvidia驱动总开关
  #   boot.blacklistedKernelModules = [ "nouveau" ];    # 把开源nouveau驱动拉入黑名单不跟nvidia open驱动抢

  nixpkgs.config = {
    nvidia.acceptLicense = true; # 同意NVIDIA协议
  };

  # NVIDIA显卡驱动
  hardware.nvidia = {
    open = true; # 启用开源 NVIDIA 内核模块
    nvidiaSettings = true; # 安装 NVIDIA 控制面板
    modesetting.enable = true; # 硬件加速渲染（必须开）

    # 手动强制指定使用 NVIDIA 驱动包，而不是 NixOS 自动匹配的稳定版驱动。
    #     package = config.boot.kernelPackages.nvidiaPackages.stable;   # nixpkgs 筛选过的稳定驱动，**系统默认使用**，兼容性优先。
    #     package = config.boot.kernelPackages.nvidiaPackages.beta;   # NVIDIA Beta 测试驱动，新特性，但稳定性不保证。
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  programs.atop.atopgpu.enable = true; # GPU 监控工具

  programs.gpu-screen-recorder.enable = true; # NVIDIA 硬件加速录屏

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
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva
      libva-utils
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
    ];
  };
}
