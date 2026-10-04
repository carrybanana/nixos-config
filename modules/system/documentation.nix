# /etc/nixos/modules/system/default.nix
{ ... }:

{
  # 启用系统文档功能，特别是 man 手册（manual pages）并优化其使用体验。
  documentation = {
    enable = true;
    man = {
      cache.enable = true;
      man-db = {
        enable = true;
      };
    };
  };
}
