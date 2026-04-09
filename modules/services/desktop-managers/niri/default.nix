{ config, lib, pkgs, inputs, ... }:

{
  # ==============================================
  # 1. Niri：启用官方模块化配置（替代直接加 systemPackages）
  # ==============================================
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
  };

  # ==============================================
  # 2. Noctalia：无官方模块，保留 systemPackages 安装
  # ==============================================
  environment.systemPackages = with pkgs; [
    # Noctalia 安装（无模块，直接加系统包）
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

    fuzzel        # niri默认的启动器
    alacritty	  # niri默认的终端
  ];

  # ✅ NIXOS 官方原生：把 config.kdl 放入 ~/.config/niri
  users.users.carry = {
    home.file.".config/niri/config.kdl".source = ./config.kdl;
  };
}
