{ config, lib, pkgs, inputs, ... }:

{
  # 只管理配置文件,允许双向编辑：改 ~/.config 会同步回 /etc/nixos
  home.file.".config/niri/config.kdl" = {
    source = ./config.kdl;
    readable = true;
    writable = true;      # 允许你直接编辑 ~/.config 里的文件
  };
}
