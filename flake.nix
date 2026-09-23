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

    # use release branch for cached builds
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
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
    nix-cachyos-kernel,
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
          ./hosts/desktop/hardware-configuration.nix  # 硬件配置，用于加载硬件扫描结果
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

          ({ pkgs, ... }: {
          nixpkgs.overlays = [
            # pinned overlay，优先拉取预编译缓存，推荐
            nix-cachyos-kernel.overlays.pinned
            # 二选一，不要同时开两个
            # nix-cachyos-kernel.overlays.default
          ];

          # ===== 这里选择内核，我推荐 bore x86_64-v3 =====
#           boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-x86_64-v3;
          boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;

          # XFS：内核默认已经开启XFS支持，只需要声明支持的文件系统
#           boot.supportedFilesystems = [ "xfs" ];

          # 如果你需要ZFS才加下面这行，你只用XFS，删掉！
          # boot.zfs.package = config.boot.kernelPackages.zfs_cachyos;
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
