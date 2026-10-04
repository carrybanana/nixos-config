# /etc/nixos/modules/system/default.nix

{ config, lib, pkgs, inputs, ... }:

{
  # 磁盘swapfile：8GiB兜底，XFS无需额外参数
#   swapDevices = [
#     {
#       device = "/swapfile";
#       size = 8*1024;        # MiB单位，8G
#       priority = 1;         # 磁盘swap低优先级，zram耗尽才使用
#     }
#   ];
  # zram‑swap 内存压缩交换，优先使用
  zramSwap = {
    enable = true;
    memoryPercent = 25;     # 32G →最多8G物理内存用于zram，压缩后可达14‑18G有效swap
#     priority = 100;         # zram最高优先级，先耗尽zram才走磁盘swapfile
    algorithm = "zstd";     # 压缩算法，zstd平衡速度与压缩率
  };
}
