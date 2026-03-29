{ config, lib, pkgs, ... }:

{
  # 导入级模块
  imports = [
    ./kitty.nix
  ];
}
