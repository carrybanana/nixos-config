# /etc/nixos/modules/system/default.nix

{ config, lib, pkgs, ... }:

{
  imports = [
    ./kvm.nix  # 相对路径导入
  ];
}
