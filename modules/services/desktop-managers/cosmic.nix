{ config, lib, pkgs, ... }:

{
  # kde桌面环境
  services = {
    desktopManager.cosmic.enable = true;
  };
}
