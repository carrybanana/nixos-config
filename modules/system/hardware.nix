# /etc/nixos/modules/system/default.nix

{ pkgs, ... }:

{
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
