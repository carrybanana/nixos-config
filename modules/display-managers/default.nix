{ config, lib, pkgs, ... }:

{
  # 导入级模块
  imports = [
    ./sddm.nix
#    ./plasma-login-manager.nix
  ];
}
