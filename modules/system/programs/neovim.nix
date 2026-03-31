{ inputs, config, pkgs, lib, ... }:

{
  # ✅ 从 flake 导入 NixVim
  imports = [ inputs.nixvim.nixosModules.nixvim ];

  # sudo 显示/剪贴板兼容
  security.sudo.extraConfig = ''
    Defaults env_keep += "WAYLAND_DISPLAY XAUTHORITY DISPLAY XDG_RUNTIME_DIR"
  '';

  # ======================
  # Neovim 主配置
  # ======================
  programs.nixvim = {
    enable = true;        # 启用 NixVim
#     vimAlias = true;      # 输入 vim → 自动打开 nvim
#     viAlias = true;       # 输入 vi → 自动打开 nvim
    defaultEditor = false;# 不设为系统默认编辑器

    # 系统依赖
    extraPackages = with pkgs; [
      ripgrep
      fd

      # 固定 tree-sitter 0.26.7
      (tree-sitter.overrideAttrs (old: rec {
        version = "0.26.7";
        src = fetchFromGitHub {
          owner = "tree-sitter";
          repo = "tree-sitter";
          rev = "v${version}";
          hash = "sha256-O3c2djKhM+vIYunthDApi9sw/gFH/FBME1uR4N+9MFM=";
        };
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
          llvmPackages.libclang
          rustPlatform.bindgenHook
        ];
        LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
        patches = [];
        doCheck = false;
        cargoDeps = rustPlatform.importCargoLock {
          lockFile = "${src}/Cargo.lock";
        };
      }))
    ];

    # 基础编辑器设置
    opts = {
      number = true;
      guicursor = "";

      foldcolumn = "0";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      smartindent = false;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
    };

    # Lua 增强配置
    extraConfigLua = ''
      -- 取消 gc 快捷键
      vim.keymap.del('n', 'gc')
      vim.keymap.del('x', 'gc')

      -- 自动保存/加载视图（折叠记忆）
      vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
        pattern = { "*.*" },
        callback = function()
          if vim.bo.buftype == "" then
            vim.cmd("silent! mkview")
          end
        end,
      })
      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = { "*.*" },
        callback = function()
          if vim.bo.buftype == "" then
            vim.cmd("silent! loadview")
          end
        end,
      })
    '';

    # 额外插件
    extraPlugins = with pkgs.vimPlugins; [
      coc-nvim
      promise-async
    ];

    # 插件配置
    plugins = {
      nvim-treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ nix ];
      };

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      nvim-ufo = {
        enable = true;
        settings = {
          provider_selector = ''
            function(bufnr, filetype, buftype)
              return { 'treesitter', 'indent' }
            end
          '';

          fold_virt_text_handler = ''
            function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (' 󰁂 %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, {chunkText, hlGroup})
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, {suffix, 'MoreMsg'})
                return newVirtText
            end
          '';
        };
      };

      image.enable = true;
      flash.enable = true;
      markdown-preview.enable = true;
      telescope.enable = true;
      web-devicons.enable = true;
      Comment.enable = true;
      which-key.enable = true;
      mini.enable = true;

      neo-tree = {
        enable = true;
        settings = {
          filesystem = {
            follow_current_file = {
              enabled = true;
              leaveDirsOpen = false;
            };
            filtered_items = {
              visible = true;
              showHidden = true;
              showGitignored = false;
            };
          };
        };
      };
    };
  };
}
