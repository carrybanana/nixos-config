# /etc/nixos/modules/system/programs.nix

{ config, lib, pkgs, ... }:

{
  # 启用 AppImage 直接运行支持
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
