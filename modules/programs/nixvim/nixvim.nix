{
  pkgs,
  ...
}:

{
  programs.nixvim = {
    enable = true;

    opts = {
      number = true; # 显示绝对行号
      relativenumber = true; # 同时显示相对行号（方便跳转）
    };

    # 空格键作为 Leader
    globals.mapleader = " ";

    # LSP：clangd 负责 C++ 智能；CMake 插件：构建、运行、调试的核心
    plugins = {
      lsp = {
        enable = true;
        servers.clangd = {
          enable = true;
          package = pkgs.llvmPackages_23.clang-tools;
          #           extraOptions = {
          #             fallbackFlags = [ "-std=c++26" ];
          #           };
        };
      };

      # 用 blink-cmp
      blink-cmp = {
        enable = true;
        settings = {
          # 1. 补全来源：lsp (clangd) 和 buffer 是核心
          sources.default = [
            "lsp"
            "path"
            "buffer"
          ];

          # 2. 使用内置的 "default" 预设键位（推荐新手先用这个）
          keymap.preset = "default";

          # 3. (可选) 自定义部分快捷键，覆盖预设
          # keymap = {
          #   "<C-Space>" = [ "show" "fallback" ];   # 手动触发补全
          #   "<CR>" = [ "accept" "fallback" ];      # 回车确认
          #   "<C-j>" = [ "select_next" "fallback" ]; # 向下选择
          #   "<C-k>" = [ "select_prev" "fallback" ]; # 向上选择
          # };
        };
      };

      # C++ 调试还需要 lldb 适配器，否则 CMakeDebug 仍不可用
      dap.enable = true;
      dap-lldb.enable = true;

      cmake-tools = {
        enable = true;
        settings = {
          cmake_build_directory = "build";

          # 让 CMake 自动生成 compile_commands.json，clangd 需要它；并用 Ninja 作为生成器
          cmake_generate_options = {
            "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" = true;
            "-G" = "Ninja";
          };

          # 让 CMakeDebug 使用 lldb 适配器
          cmake_dap_configuration = {
            name = "cpp";
            type = "lldb";
            request = "launch";
          };
        };
      };
    };

    # 快捷键
    keymaps = [
      {
        key = "<leader>cb";
        mode = "n";
        action = "<cmd>CMakeBuild<CR>";
        options.desc = "CMake: 编译项目";
      }

      {
        key = "<leader>cr";
        mode = "n";
        action = "<cmd>CMakeRun<CR>";
        options.desc = "CMake: 编译并运行";
      }

      {
        key = "<leader>cd";
        mode = "n";
        action = "<cmd>CMakeDebug<CR>";
        options.desc = "CMake: 调试";
      }

      {
        key = "<leader>ct";
        mode = "n";
        action = "<cmd>CMakeSelectLaunchTarget<CR>";
        options.desc = "CMake: 选择运行/调试目标";
      }
    ];
  };
}
