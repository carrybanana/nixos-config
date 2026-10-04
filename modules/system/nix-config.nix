# /etc/nixos/modules/system/default.nix

{ config, lib, pkgs, inputs, ... }:

{
  # 全局 Nix 镜像配置（已加入：清华+中科大+官方）
  nix = {
    settings = {
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store" # 上交
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" # 清华
        "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大
        "https://cache.nixos.org/"  # 官方兜底
        "https://nix-community.cachix.org"

        "https://attic.xuyh0120.win/lantian"  # cachyos 内核缓存
      ];
      # 仅保留官方公钥（清华/中科大无独立公钥）
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="  # 官方源的公钥
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # nix-community公钥

        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="  # cahcyos内核缓存公钥
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
}
