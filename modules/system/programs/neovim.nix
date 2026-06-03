{ config, pkgs, lib, ... }:

{
  # ======================
  # Neovim 主配置
  # ======================
  programs.neovim = {
      enable = true;        # 启用 NixVim
#     vimAlias = true;      # 输入 vim → 自动打开 nvim
#     viAlias = true;       # 输入 vi → 自动打开 nvim
    defaultEditor = false;# 不设为系统默认编辑器
  };
}
