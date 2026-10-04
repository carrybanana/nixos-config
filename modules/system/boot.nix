# /etc/nixos/modules/system/default.nix

{ pkgs, ... }:

{
  # 引导加载器配置
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;

        extraEntries = ''
          menuentry "CachyOS (nvme2n1 Limine)" --class gnu-linux --class os {
            insmod part_gpt
            insmod fat
            insmod chain
            search --no-floppy --fs-uuid --set=root C372-FAC2
            chainloader /EFI/limine/limine_x64.efi
          }
        '';
      };
      efi = {
        canTouchEfiVariables = true; # 允许修改EFI变量，支持UEFI引导
        efiSysMountPoint = "/boot";
      };
    };
  };

  # ============ 内核选择，每次只取消注释其中一行 ============

  #   boot.kernelPackages = pkgs.linuxKernel.packages.linux;                  # nixpkgs 默认主线内核

  #   boot.kernelPackages = pkgs.linuxPackages_latest;                        # 主线新版内核

  #     boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;            # Zen调优内核，均衡桌面游戏

  #     boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;         # Xanmod，跟随nixpkgs，补丁更多

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest; # Xanmod 上游滚动最新，激进风险大

  #   # chchyos内核
  #   nixpkgs.overlays = [
  #     # pinned overlay，优先拉取预编译缓存，推荐
  #     inputs.nix-cachyos-kernel.overlays.pinned
  #     # 二选一，不要同时开两个
  #     # nix-cachyos-kernel.overlays.default
  #   ];
  #   # ===== 这里选择内核，我推荐 bore x86_64-v3 =====
  # #  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-x86_64-v3;
  #   boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;
}
