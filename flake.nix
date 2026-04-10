{
  description = "系统级配置入口（管理NixOS系统与服务）";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos";

    # niri
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # noctalia shell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";         # Hyprland 主仓库
    };

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager/master"; # home-manager master对应unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake-utils 辅助工具
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    # agenix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = {
    self,
    nixpkgs,
    niri,
    noctalia,
    hyprland,
    home-manager,
    flake-utils,
    agenix,
    nixvim,
    catppuccin,
    ...
  } @ inputs:
  let
    system = "x86_64-linux";

  in {
    nixosConfigurations = {

      # === 台式机配置 ===
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;         # 传递所有flakes源
        };

        modules = [
          ./hosts/desktop/configuration.nix           # 主系统配置
          ./hosts/desktop/hardware-configuration.nix  # 原硬件配置，用于加载硬件扫描结果
          ./modules/default.nix

          agenix.nixosModules.default
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            environment.systemPackages = [agenix.packages.${system}.default];
          }

        ];
      };

      # === 笔记本配置 ===
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          agenix.nixosModules.default  # ← 启用 agenix 加密模块
          ./hosts/laptop/configuration.nix
          ./hosts/laptop/hardware-configuration.nix
          ./modules/default.nix

          agenix.nixosModules.default
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            environment.systemPackages = [agenix.packages.${system}.default];
          }

        ];
      };
    };
  };
}
