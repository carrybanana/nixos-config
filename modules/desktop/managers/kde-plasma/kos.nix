{
  inputs,
  ...
}:
{
  # 导入 NextKde 提供的 NixOS 模块
  imports = [
    inputs.nextkde.nixosModules.kos
  ];

  # 启用 KOS 桌面 Shell 核心服务
  services.kos.enable = false;

  # （可选）启用独立的天气应用
  # services.kos.weather.enable = true;
}
