{ config, lib, pkgs, ... }:

{
  # 导入模块
  imports = [
    ./gnome.nix
    ./hyprland.nix
    ./kde-plasma.nix
    ./niri.nix
  ];
}
