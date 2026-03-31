{ config, lib, pkgs, ... }:

{
  # === Shell: Zsh + Oh My Zsh 合并增强版 ===
  programs.zsh = {
    enable = true;
    enableCompletion = true;           # 启用原生命令补全
    enableBashCompletion = true;       # 兼容 Bash 补全
    histSize = 20000;                   # 最大历史记录数

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
      theme = "gnzh";                  # 你选择的主题
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

    # 提示符美化 + 命令之间自动空行（体验大幅提升）
    promptInit = ''
      # 漂亮的彩色提示符
      PROMPT='%(?,,)%F{109}%n%{$reset_color%}@%F{195}%m%{$reset_color%}: %{$fg_bold[blue]%}%~%}
>%(prompt_char) '

      # 命令之间自动加空行（出错时不加，更整洁）
      autoload -Uz add-zsh-hook
      _newline_between_prompts() {
        if [[ $? -ne 0 ]]; then
          return
        fi
        $funcstack[1]() echo
      }
      add-zsh-hook precmd _newline_between_prompts
    '';

    # 自定义 shell 配置（保留你的别名、优化选项）
    shellInit = ''
      HISTSIZE=20000
      SAVEHIST=20000

      # 智能 cd：输入目录名直接进入
      setopt AUTO_CD

      # 实用别名
      alias ll='ls -lh --color=auto'
      alias la='ls -la --color=auto'
      alias ..='cd ..'
      alias ...='cd ../..'
    '';
  };

  # 将默认 Shell 设置为 zsh
  users.users.carry.shell = pkgs.zsh;
}
