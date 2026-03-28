{ config, lib, pkgs, ... }:

{
  # 导入级模块
  imports = [
    ./fonts/default.nix                 # 字体
    ./input-method/default.nix          # 输入法
    ./services/default.nix              # 系统服务配置
    ./system/default.nix                # 基础系统设置
    ./virtualisation/default.nix        # 虚拟化服务
  ];
}
