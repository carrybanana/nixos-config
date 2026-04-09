{ config, lib, pkgs, ... }:

{
  # Steam游戏平台
  programs.steam = {
    enable = true;
    fontPackages = with pkgs; [
      source-han-sans
    ];
  };
}
