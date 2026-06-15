{ config, lib, pkgs, inputs, ... }:

{
  home.file.hypr-config = {
    source = ./hypr; # 本地目录 ./hypr/ 下放所有配置
    target = ".config/hypr";
    recursive = true;
    # hyprland 重载钩子，文件变更自动刷新
    onChange = "hyprctl reload";
    # 本地手动改了文件切换报错时开启
    force = true;
  };
}
