{ config, lib, pkgs, ... }:

{
  # 系统级输入法（Fcitx5）
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      addons = with pkgs; [
        rime-data
        fcitx5-gtk
        fcitx5-rime
        qt6Packages.fcitx5-chinese-addons  # 拼音/五笔支持
        qt6Packages.fcitx5-qt              # Qt应用支持
        fcitx5-gtk  	           	# GTK应用支持
        qt6Packages.fcitx5-configtool      # 图形化配置
        fcitx5-nord
        fcitx5-pinyin-zhwiki
        fcitx5-lua
      ];
      waylandFrontend = true;  # 支持KDE Wayland会话
    };
  };
  # 2. 环境变量：仅保留 XMODIFIERS（@im=fcitx，官方要求，不是fcitx5）
  # 【关键】删除所有 GTK_IM_MODULE/QT_IM_MODULE 全局配置，避免和 Wayland 冲突
  environment.variables = lib.mkOverride 999 {  # 低优先级，防止和其他模块冲突
    XMODIFIERS = "@im=fcitx";  # 官方明确：Wayland 下 XMODIFIERS 用 fcitx（不是5）
    INPUT_METHOD = "fcitx5";   # 仅标识输入法，不影响实际运行
  };
}
