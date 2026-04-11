{ config, lib, pkgs, inputs, ... }:

{
  # 只管理配置文件，别的什么都不做
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
}
