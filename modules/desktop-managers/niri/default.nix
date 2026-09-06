{ config, lib, pkgs, inputs, ... }:

{
  # Niri：启用官方模块化配置（替代直接加 systemPackages）
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
  };
}
