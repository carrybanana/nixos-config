{
  ...
}:

{
  programs.nixvim = {
    enable = true;

    # 空格键作为 Leader
    globals.mapleader = " ";

    # LSP：clangd 负责 C++ 智能；CMake 插件：构建、运行、调试的核心
    plugins = {
      lsp = {
        enable = true;
        servers.clangd = {
          enable = true;
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
