# /etc/nixos/modules/system/programs.nix

{ config, lib, pkgs, ... }:

{
  # neovim
  # === 启用 Neovim（使用 configure 选项，Lua 格式） ===
  programs.neovim = {
    # 1. 核心开关：启用 Neovim（无需额外配置 extraLuaConfig，所有配置放在 configure 中）
    enable = true;

    # 2. 核心配置：使用 configure 选项（attribute set 类型，对应你看到的示例）
    configure = {
      # === Lua 自定义配置（对应你的需求，替代 extraLuaConfig） ===
      customLuaRC = ''
        -- 基础配置（和之前的 Lua 配置完全一致）
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.autoindent = true
        vim.opt.smartindent = true
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
        vim.opt.cursorline = true
        vim.opt.hlsearch = true
        vim.opt.incsearch = true
        vim.opt.ignorecase = true
        vim.opt.smartcase = true
        vim.opt.encoding = "utf-8"
        vim.opt.mouse = "a"

        -- 自定义快捷键
        vim.keymap.set("n", "<C-s>", ":w<CR>")
        vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a")

        -- 可选：主题配置（需在 packages 中安装 gruvbox-nvim）
        -- vim.cmd("colorscheme gruvbox")
      '';
      # === 可选：Vimscript 自定义配置（如果有遗留 Vimscript 代码，可写在这里） ===
      # customRC = ''
      #   " Vimscript 代码示例
      #   set laststatus=2
      # '';

      # === 插件管理（核心：分 start（启动加载）和 opt（手动加载）） ===
      packages.myVimPackage = with pkgs.vimPlugins; {
        # 启动即加载的插件（对应之前的 plugins 选项）
        start = [
          gruvbox-nvim        # 经典主题
          telescope-nvim      # 搜索插件
          plenary-nvim        # telescope 依赖
        ];

        # 手动加载的插件（需要时在 Neovim 中输入 :packadd 插件名 加载，目前留空即可）
        opt = [ ];
      };
    };
  };
}
