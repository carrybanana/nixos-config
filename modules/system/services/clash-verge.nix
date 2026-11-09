{
  pkgs,
  ...
}:

{
  # V2RayA代理服务
  # services.v2raya.enable = true;
  # 可选：防火墙开放V2RayA端口（如1080）
  # networking.firewall.allowedTCPPorts = [ 1080 ];

  # Clash Verge 代理客户端
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    group = "wheel";
    tunMode = true;
    serviceMode = true;

    # 关键修改：覆盖默认的 clash-verge-rev 包
    package = pkgs.clash-verge-rev.overrideAttrs (oldAttrs: {
      # 方案一：直接取消环境变量，让 aws-lc-sys 从源码构建
      AWS_LC_SYS_USE_SYSTEM = null;
    });
  };
}
