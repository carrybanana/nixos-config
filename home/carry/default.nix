{ inputs, ... }:

{
  imports = [
    ./hyprland
    ./kitty
    ./niri
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
  };

  home = {
    username = "carry";
    homeDirectory = "/home/carry";
    stateVersion = "26.11";
  };
}
