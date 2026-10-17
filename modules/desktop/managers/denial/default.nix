{
  inputs,
  ...
}:

{
  # 引入 Denial 官方 NixOS 模块（Wayland 会话、portal、systemd 用户单元等）
  imports = [ inputs.denial.nixosModules.default ];

  # Denial 的二进制缓存（用 extra- 前缀，自动追加到 nix-config.nix 的列表后）
  nix.settings.extra-substituters = [
    "https://denial.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "denial.cachix.org-1:wd8YTnvPmugFrtdMJWtR1XdVknR3/g2nmBJkT+vAruo="
  ];

  programs.denial = {
    enable = true;

    # 插件管理器（独立包，不污染主 pkgs.denial 闭包）
    plugins.enable = true;

    # 通常不需要，仅在宿主 glibc 过低或你想强制自编译时打开
    # engine.buildFromSource = true;

    # Denial 模块默认会启动 PolicyKit 认证代理。
    # 如果你以后改用 hyprpolkitagent 服务，需要把这里关掉避免两个 agent 打架。
    # polkitAgent.enable = false;

    # Denial 默认启用 I2C 访问以支持 DDC 显示器亮度/对比度控制
    # ddc.enable = false;
  };
}
