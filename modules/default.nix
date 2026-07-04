{ config, lib, pkgs, inputs, ... }:

{
  # 导入级模块
  imports = [
    ./fonts/default.nix                 # 字体
    ./input-method/default.nix          # 输入法
    ./services/default.nix              # 系统服务配置
    ./system/default.nix                # 基础系统设置
    ./virtualisation/default.nix        # 虚拟化服务
  ];

  # 允许非自由软件（系统级，如NVIDIA驱动、Chrome）
  nixpkgs.config = {
    allowUnfree = true;          # 允许闭源软件
    nvidia.acceptLicense = true; # 同意NVIDIA协议
  };

  # 全局 Nix 镜像配置（已加入：清华+中科大+官方）
  nix = {
    settings = {
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" # 清华
        "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大
        "https://cache.nixos.org/"  # 官方兜底
        "https://nix-community.cachix.org"
      ];
      # 仅保留官方公钥（清华/中科大无独立公钥）
      trusted-public-keys = [
        "mirrors.tuna.tsinghua.edu.cn-1:4YeXhlzW0NlzcqF9000LL5z0nQjN1L3QkA4Uvb01Xo0=" # 清华源公钥
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="  # 官方源的公钥
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # nix-community公钥
      ];
      trusted-users = [ "root" "carry" ]; # 添加可信用户
      experimental-features = [ "nix-command" "flakes" ]; # 启用实验性功能：nix命令增强和flakes支持
      auto-optimise-store = true;
      sandbox = true;
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      download-buffer-size = 128M
    '';

    gc = {
      automatic = true;
      dates = "Mon *-*-* 01:00:00";
      options = "--delete-older-than 30d";
      persistent = true;
      randomizedDelaySec = "30min";
    };
  };

  # 集成 Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.carry = import ../home/carry/default.nix;
  };
}
