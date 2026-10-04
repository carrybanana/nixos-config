{ ... }:

{
  # 导入级模块
  imports = [
    ./desktop/default.nix
    ./hardware/default.nix
    ./programs/default.nix
    ./system/default.nix
    ./virtualisation/default.nix
  ];

  # 允许非自由软件（系统级，如NVIDIA驱动、Chrome）
  nixpkgs.config = {
    allowUnfree = true; # 允许闭源软件
  };
}
