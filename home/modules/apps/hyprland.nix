{ pkgs, ... }:
{
#   wayland.windowManager.hyprland = {
#     enable = true;
#     package = pkgs.hyprland; # 用系统同版本，保持一致
#     xwayland.enable = true; # 与系统层一致
#     settings = null;           # 👇 关键：禁用 HM 自动生成 hyprland.conf，只让 home.file 管理
#
# #     # 核心：用 Nix 写 Hyprland 配置（完全声明式）
# #     settings = {
# #
# #     };
#   };

  # 直接引用外部 hyprland.conf 文件 ✅✅✅
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
}
