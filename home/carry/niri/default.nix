{ config, lib, pkgs, inputs, ... }:

{
  # 只管理配置文件
  home.file.".config/niri/config.kdl" = {
    source = ./config.kdl;
    executable = false;  # 可写文件不需要执行权限
  };
}
