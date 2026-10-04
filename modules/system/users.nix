# /etc/nixos/modules/system/default.nix

{ config, lib, pkgs, inputs, ... }:

{
  # 仅保留「系统级用户配置」（用户创建、组权限，用户专属配置放home/）
  users.users.carry = {
    isNormalUser = true;
    description = "carry";
    home = "/home/carry";
    hashedPassword = "$6$SVz6B.Fb2meBkDtX$2ntIrV66eLVEnrLDW0yFGfcnEjt1.PGRvM/8Zkp87OPRzwwZ5evHWfBTvPaMwtiG/ImE9HJ0nZxoA4ewpc3/n0";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "kvm" "libvirtd" ];  # 网络管理+sudo权限
    uid = 1000;  # 可选：固定UID，避免多设备同步冲突
  };
}
