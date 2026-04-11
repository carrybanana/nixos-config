{ config, lib, pkgs, inputs, ... }:

{
  # 导入用户级模块
  imports = [
    ./hyprland
    ./kitty
    ./niri
    ./secrets
    ./shell
  ];

  # 用户基础设置（Shell、Home目录）
  home = {
    username = "carry";
    homeDirectory = "/home/carry";
    stateVersion = "26.05";  # 绑定系统版本
  };
}
