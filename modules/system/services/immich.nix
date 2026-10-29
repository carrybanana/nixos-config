{
  ...
}:

{
  # ==========================================
  # Immich 纯内网自托管配置
  # ==========================================
  # 1. 启用NVIDIA容器工具包 (必须，让容器能访问GPU)
  hardware.nvidia-container-toolkit.enable = true;

  # 2. Immich服务配置
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";
    openFirewall = true;
    machine-learning.enable = true;

    # 3. 告诉Immich的机器学习服务使用CUDA
    environment = {
      MACHINE_LEARNING_DEVICE = "cuda";
    };
  };
}
