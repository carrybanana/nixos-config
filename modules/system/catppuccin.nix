# /etc/nixos/modules/system/default.nix

{ ... }:

{
  # Catppuccin 主题
  catppuccin = {
    enable = true;
    autoEnable = true; # 和enable保持一致即可消除警告
  };
}
