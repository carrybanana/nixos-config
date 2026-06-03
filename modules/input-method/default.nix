{ config, lib, pkgs, ... }:

{
  # 导入级模块
  imports = [
    ./fcitx5.nix
  ];
}
