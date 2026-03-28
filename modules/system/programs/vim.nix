# /etc/nixos/modules/system/programs.nix

{ config, lib, pkgs, ... }:

{
  # vim
  programs.vim = {
    enable = true;
    package = pkgs.vim-full; 	# 完整版 Vim 功能
  };
}
