{ config, lib, pkgs, ... }:

{
  # 启用 OnlyOffice
  services.onlyoffice = {
    enable = true;
  };
}
