{
  ...
}:

{
  # V2RayA代理服务
  # services.v2raya.enable = true;
  # 可选：防火墙开放V2RayA端口（如1080）
  # networking.firewall.allowedTCPPorts = [ 1080 ];



  # 覆盖 clash-verge-rev-unwrapped 的构建方式
  nixpkgs.overlays = [
    (final: prev: {
      clash-verge-rev-unwrapped = prev.clash-verge-rev-unwrapped.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
          final.cmake
          final.nasm
        ];
        preBuild = (oldAttrs.preBuild or "") + ''
          unset AWS_LC_SYS_USE_SYSTEM
          export AWS_LC_SYS_PREBUILT_NASM=0
        '';
      });
    })
  ];

  # Clash Verge 代理客户端
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    group = "wheel";
    tunMode = true;
    serviceMode = true;
  };
}
