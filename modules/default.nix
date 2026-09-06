{ config, lib, pkgs, inputs, ... }:

{
  # 导入级模块
  imports = [
    ./desktop-managers/default.nix      # 桌面
    ./display-managers/default.nix      # 锁屏
    ./fonts/default.nix                 # 字体
    ./input-method/default.nix          # 输入法
    ./programs/default.nix              # 应用
    ./system/default.nix                # 基础系统设置
    ./virtualisation/default.nix        # 虚拟化服务
  ];

  # 允许非自由软件（系统级，如NVIDIA驱动、Chrome）
  nixpkgs.config = {
    allowUnfree = true;          # 允许闭源软件
    nvidia.acceptLicense = true; # 同意NVIDIA协议
  };

  # 集成 Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.carry = import ../home/carry/default.nix;
  };
}
