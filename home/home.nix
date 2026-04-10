{ config, lib, pkgs, inputs, ... }:

{
  # 导入用户级模块
  imports = [
    ./kitty/default.nix
  ];

  # 用户基础设置（Shell、Home目录）
  home = {
    username = "carry";
    homeDirectory = "/home/carry";
    stateVersion = "unstable";  # 绑定系统版本
  };
}
