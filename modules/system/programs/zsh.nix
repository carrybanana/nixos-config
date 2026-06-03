{ config, lib, pkgs, ... }:

{
  # === Shell: Zsh + Oh My Zsh 合并增强版 ===
  programs.zsh = {
    enable = true;
    enableCompletion = true;           # 启用原生命令补全
    enableBashCompletion = true;       # 兼容 Bash 补全
    histSize = 20000;                  # 内存缓存

    # 命令自动建议（灰色提示）
    autosuggestions = {
      enable = true;
      strategy = [ "history" "completion" ];
    };

    # 实时语法高亮
    syntaxHighlighting.enable = true;

    # Oh My Zsh 核心配置（保留你喜欢的主题 + 插件）
    ohMyZsh = {
      enable = true;
      theme = "gnzh";
      plugins = [
        "git"
        "docker"
        "kubectl"
        "sudo"
        "extract"
        "history"
        "colorize"
        "command-not-found"
        "colored-man-pages"
        "fancy-ctrl-z"
      ];
    };
  };

  # 将默认 Shell 设置为 zsh
  users.users.carry.shell = pkgs.zsh;
}
