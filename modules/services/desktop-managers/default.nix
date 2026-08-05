{ config, lib, pkgs, ... }:

{
  # 导入模块
  imports = [
    ./hyprland/default.nix
#     ./niri/default.nix
#     ./cosmic.nix
#     ./gnome.nix
#     ./kde-plasma.nix
    ./noctalia.nix
  ];
}
