{ config, lib, pkgs, ... }:

{
  # 安装 Google Chrome 到当前用户环境
  home.packages = with pkgs;[
    google-chrome
  ];
}
