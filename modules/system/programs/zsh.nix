# /etc/nixos/modules/system/programs.nix

{ config, lib, pkgs, ... }:

{
  # === Shell: Zsh + Oh My Zsh（对齐模块源码选项） ===
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;           # 启用 命令自动建议（灰色文字提示）（历史命令）
    syntaxHighlighting.enable = true;       # 启用 实时语法高亮,错误命令变红，关键字高亮

    ohMyZsh = {
      enable = true;

      # 主题和插件
      theme = "gnzh";
      plugins = [
        "git"
        "docker"
        "kubectl"
        "sudo"
        "extract"
        "history"
      ];
    };

    # 可选：自定义 Zsh 配置（追加到 .zshrc）
    shellInit = ''
      # 提升历史记录大小
      HISTSIZE=10000
      SAVEHIST=10000

      # 更智能的 cd,输入目录名直接 cd
      setopt AUTO_CD

      # 别名
      alias ll='ls -lh --color=auto'
      alias la='ls -la --color=auto'
      alias ..='cd ..'
      alias ...='cd ../..'
    '';
  };
}
