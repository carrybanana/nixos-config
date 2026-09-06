{ config, lib, pkgs, ... }:

{
  # gnome桌面环境
  services = {
    desktopManager.gnome.enable = true;
  };
}
