{ pkgs, ... }:
{
  # 直接引用外部 hyprland.conf 文件 ✅✅✅
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
}
