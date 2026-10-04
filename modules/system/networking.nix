# /etc/nixos/modules/system/default.nix

{ config, lib, pkgs, inputs, ... }:

{
  # 网络基础配置
  networking = {
    hostName = "nixos";     # 设置主机名
    networkmanager.enable = true;  # 图形化网络管理,启用NetworkManager，支持无线网络管理
  };

#   # 系统级代理设置
#   networking.proxy = {
#     default = "http://127.0.0.1:7897";
#     httpProxy = "http://127.0.0.1:7897";
#     httpsProxy = "http://127.0.0.1:7897";
#     noProxy = "localhost,127.0.0.1,::1,*.local";
#   };
}
