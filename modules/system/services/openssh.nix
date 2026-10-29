{
  ...
}:

{
  # SSH服务（远程登录）
  services.openssh.enable = true;
  # 可选：防火墙开放SSH端口（如需远程访问）
  # networking.firewall.allowedTCPPorts = [ 22 ];
}
