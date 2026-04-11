{ pkgs, ... }:
{
  # 导入用户级模块
  imports = [
    ./kitty.nix
  ];
}
