# /etc/nixos/modules/system/programs.nix

{ config, lib, pkgs, ... }:

{
  # 启用Fish Shell
  programs.fish = {
    enable = true;
  };
}
