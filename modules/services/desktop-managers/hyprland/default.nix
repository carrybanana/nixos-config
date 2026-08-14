{ config, lib, pkgs, inputs, ... }:

{
  # hyprland
  nix.settings = {
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    substituters = [
      "https://hyprland.cachix.org"
    ];
  };

  # 启用 Hyprland 系统级模块（核心：提供会话文件、依赖）
  programs.hyprland = {
    enable = true;
    # 使用 Flake 引入的 Hyprland 包（避免版本不一致）
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # 同步 xdg-desktop-portal-hyprland 版本（修复剪贴板/文件选择器问题）
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

#     # 启用 hyprland-plugins 插件
#     extraPackages = with pkgs; [
#       hyprland-plugins
#     ];

    withUWSM = false;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprpolkitagent       # Polkit授权
    kdePackages.dolphin
  ];
}
