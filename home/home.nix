# 接收 stateVersion 参数（可选，但建议显式声明）
{ config, lib, pkgs, stateVersion ? config.system.stateVersion, ... }:

{
  # 导入用户级模块
  imports = [
    ./modules/shell/default.nix
    ./modules/apps/default.nix
  ];

  # 用户基础设置（Shell、Home目录）
  home = {
    username = "carry";
    homeDirectory = "/home/carry";
    stateVersion = stateVersion;  # ← 启用这行，绑定系统版本（关键）
  };
}
