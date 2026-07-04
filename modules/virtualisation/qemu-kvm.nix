{ config, pkgs, lib, ... }:

{
  # 跨架构二进制模拟（binfmt）
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  # 用户权限：组名修正 libvirt，删除错误 libvirtd
  users.users.carry.extraGroups = [ "libvirt" "kvm" "disk" ];

  environment.systemPackages = with pkgs; [
    qemu_kvm
    virt-manager
    OVMFFull
    dmidecode
    virt-viewer
    virtiofsd
    dnsmasq
  ];

  # 开启 virt-manager 桌面集成
  programs.virt-manager.enable = true;

  # 标准 libvirt 模块（自动管理所有 virtqemud/virtnetworkd 等服务，无需手动定义）
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "start";

    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
      runAsRoot = true;
      # 仅按需补充设备白名单，其余由模块自动填充
      verbatimConfig = ''
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero", "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm", "/dev/rtc", "/dev/hpet",
          "/dev/sdb", "/dev/sdb1", "/dev/sda", "/dev/sda1"
        ]
      '';
    };
  };

  # KSM 内存合并，多虚拟机优化
  hardware.ksm.enable = true;
  hardware.ksm.sleep = 500;

  # 内核开启嵌套虚拟化（Intel CPU）
  boot.kernelModules = [ "kvm_intel" ];
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
  '';
}
