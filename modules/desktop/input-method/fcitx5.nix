{
  pkgs,
  ...
}:

{
  # Fcitx5
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      addons = with pkgs; [
        rime-data
        fcitx5-rime
        qt6Packages.fcitx5-chinese-addons # 拼音/五笔支持

        qt6Packages.fcitx5-qt # Qt应用支持
        qt6Packages.fcitx5-configtool # 图形化配置
        fcitx5-pinyin-zhwiki # 维基词库
      ];

      waylandFrontend = true; # 启用 Wayland 前端
    };
  };
}
