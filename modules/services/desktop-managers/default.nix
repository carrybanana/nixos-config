{ config, lib, pkgs, ... }:

{
  # 导入模块
  imports = [
    ./gnome.nix
    ./hyprland/default.nix
    ./kde-plasma.nix
    ./niri/default.nix
  ];
}
