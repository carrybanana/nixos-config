# /etc/nixos/modules/system/programs.nix

{ config, lib, pkgs, ... }:

{
  # vscode
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans  # 中文语言包
    ];
  };
}
