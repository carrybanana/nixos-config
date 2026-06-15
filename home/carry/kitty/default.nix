{ config, lib, pkgs, inputs, ... }:

{
  # 导入模块
  imports = [
    ./kitty.nix
  ];
}
