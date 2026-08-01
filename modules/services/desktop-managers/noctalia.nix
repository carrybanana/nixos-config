{ config, lib, pkgs, inputs, ... }:

{
  # Noctalia：无官方模块，保留 systemPackages 安装
  environment.systemPackages = with pkgs; [
    # Noctalia 安装（无模块，直接加系统包）
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
