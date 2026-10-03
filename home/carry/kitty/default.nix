{ config, lib, pkgs, inputs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      # 智能关闭确认
      confirm_os_window_close = 0;
      # 全部关闭都确认
      # confirm_os_window_close = 1;
    };
  };
}
