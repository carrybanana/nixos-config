{ config, lib, pkgs, ... }:

{
  # kde桌面环境
  services = {
    desktopManager.plasma6.enable = true;
  };
}
