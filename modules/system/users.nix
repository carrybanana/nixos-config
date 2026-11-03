{
  pkgs,
  ...
}:

{
  # carry
  users.users.carry = {
    isNormalUser = true;
    description = "carry";
    home = "/home/carry";
    hashedPassword = "$6$SVz6B.Fb2meBkDtX$2ntIrV66eLVEnrLDW0yFGfcnEjt1.PGRvM/8Zkp87OPRzwwZ5evHWfBTvPaMwtiG/ImE9HJ0nZxoA4ewpc3/n0";
    # 网络管理+sudo权限
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "kvm"
      "libvirtd"
    ];
    uid = 1000; # 可选：固定UID，避免多设备同步冲突
    shell = pkgs.zsh;
  };

  # maomao
  users.users.maomao = {
    isNormalUser = true;
    description = "毛毛的账号";

    # 绝对不能加 "wheel"，否则他就有了管理员权限
    extraGroups = [
      "networkmanager"
      "video"
      "audio"
    ];

    # 粘贴第一步生成的那串以 $y$j9T$ 开头的完整哈希值
    hashedPassword = "$y$j9T$72fz1RSLBdWa7EjpUHgeY0$kL4EYhJz9rlN.TqlfZRvfl92k1j4LS.0g5pe9BPmENA";
  };
}
