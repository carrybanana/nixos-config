{ config, lib, pkgs, inputs, ... }:

{
  # 只管理配置文件
  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
