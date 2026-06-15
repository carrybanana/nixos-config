{ config, lib, pkgs, inputs, ... }:

{
  home.file.niri = {
    source = ./niri;
    target = ".config/niri";
    recursive = true;
    # niri 重载命令，文件改动自动生效
    onChange = "pkill -SIGUSR1 niri";
    # 本地手动改了文件切换报错时开启
    force = true;
  };
}
