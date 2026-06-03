# /etc/nixos/modules/system/programs.nix

{ config, lib, pkgs, ... }:

{
  # 系统级应用启用 Firefox
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
  };
}
