{
  description = "系统级配置入口（管理NixOS系统与服务）";

  inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
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

    catppuccin.url = "github:catppuccin/nix";

    impermanence.url = "github:nix-community/impermanence";     # 新增：持久化模块
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
    catppuccin,
    impermanence,
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
          ./hosts/desktop/configuration.nix
          ./hosts/desktop/hardware-configuration.nix  # 原硬件配置，用于加载硬件扫描结果
          ./modules/default.nix

          impermanence.nixosModules.impermanence    # 新增：启用 impermanence
          agenix.nixosModules.default
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            environment.systemPackages = [agenix.packages.${system}.default];
          }
	  
	  # Configuration Revision
	  ({ config, lib, pkgs, ... }: {
            system.configurationRevision = self.rev or self.dirtyRev or null;
          })

        ];
      };

      # === 笔记本配置 ===
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;         # 传递所有flakes源
        };

        modules = [
          ./hosts/laptop/configuration.nix
          ./hosts/laptop/hardware-configuration.nix
          ./modules/default.nix

          impermanence.nixosModules.impermanence    # 新增：启用 impermanence
          agenix.nixosModules.default           # ← 启用 agenix 加密模块
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            environment.systemPackages = [agenix.packages.${system}.default];
          }
          
	  # Configuration Revision
	  ({ config, lib, pkgs, ... }: {
            system.configurationRevision = self.rev or self.dirtyRev or null;
          })
          
        ];
      };
    };
  };
}
