{ config, lib, pkgs, ... }:

{
  # 显示管理器（plasma-login-manager）
  services = {
    displayManager.plasma-login-manager.enable = true;
  };
}
