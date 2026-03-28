# /etc/nixos/modules/system/programs.nix

{ config, lib, pkgs, ... }:

{
  # 启用 AppImage 官方支持
  programs.appimage = {
    enable = true;
  };
}
