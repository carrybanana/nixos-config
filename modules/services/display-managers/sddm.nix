{ config, lib, pkgs, ... }:

{
  # 显示管理器（SDDM）
  services = {
    displayManager.sddm.enable = true;
  };
}
