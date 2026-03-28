# /etc/nixos/modules/system/programs.nix

{ config, lib, pkgs, ... }:

{
  # 录制软件
  programs.obs-studio = {
    enable = true;
  };
}
