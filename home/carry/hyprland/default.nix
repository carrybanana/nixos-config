{ config, lib, pkgs, inputs, ... }:

{
  # 只管理配置文件
  home.file.".config/hypr/hyprland.lua" = {
    source = ./hyprland.lua;
    executable = false;  # 可写文件不需要执行权限
  };
}
