{
  pkgs,
  ...
}:

{
  # V2RayA代理服务
  services.v2raya.enable = true;
  # 可选：防火墙开放V2RayA端口（如1080）
  # networking.firewall.allowedTCPPorts = [ 1080 ];

#   # Clash Verge 代理客户端
#   programs.clash-verge = {
#     enable = true;
#     autoStart = true;
#     group = "wheel";
#     tunMode = true;
#     serviceMode = true;
#   };

#   # throne
#   programs.throne = {
#     enable = true;
#     package = pkgs.throne; # 通常无需修改，除非你想指定特定版本
#     tunMode = {
#       enable = true;
#       setuid = false; # 建议先用默认值 false
#     };
#   };
}
