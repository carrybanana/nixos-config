{ config, lib, pkgs, ... }:

{
  programs.virt-manager.enable = true;
  # 启用 KVM 内核模块
  boot.kernelModules = [ "kvm-intel" ];  # Intel CPU
  # boot.kernelModules = [ "kvm-amd" ];   # AMD CPU
  # 启用必要的服务
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu = {
    runAsRoot = false;
    swtpm.enable = true;
    vhostUserPackages = [
      pkgs.virtiofsd
    ];
  };
  # 开启 IP 转发，这是 NAT 上网的关键
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
