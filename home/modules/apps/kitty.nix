{ pkgs, ... }: {

  # 启用 Home Manager 管理 Kitty 配置
  programs.kitty = {
    enable = true;

    settings = {
      confirm_os_window_close = 0;  # 关闭退出确认
    };
  };

}
