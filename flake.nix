{
  description = "系统级配置入口（管理NixOS系统与服务）";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # 也可以用稳定版，比如"nixos-25.05"

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
      url = "git+https://github.com/hyprwm/Hyprland.git";         # Hyprland 主仓库
#      inputs.nixpkgs.follows = "nixpkgs";
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
  };

  outputs = inputs@{
    self,
    nixpkgs,
    niri,
    noctalia,
    hyprland,
    home-manager,
    flake-utils,
    agenix,
    nixvim,
    ... }:
    let
      # 统一定义系统架构，便于维护和未来扩展
      system = "x86_64-linux";
      # 提前定义pkgs，方便传递给home.nix（可选，但更规范）
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations = {

        # === 台式机配置 ===
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };        # 关键：传递 inputs 给配置文件
          modules = [
            agenix.nixosModules.default  # ← 启用 agenix 加密模块
            ./hosts/desktop/configuration.nix           # 主系统配置
            ./hosts/desktop/hardware-configuration.nix  # 原硬件配置，用于加载硬件扫描结果
            ./modules/default.nix



            # 全局 Nix 镜像配置（已加入：清华+中科大+官方）
            ({ config, lib, ... }: {
              nix.settings = {
                substituters = [
                  "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华
                  "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大
                  "https://cache.nixos.org/"  # 官方兜底
                ];
                # ✅ 已修正：仅保留官方公钥（清华/中科大无独立公钥）
                trusted-public-keys = [
                  # 官方源的公钥
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                ];

                # 关键：添加可信用户
                # 替换 "carry" 为你的实际用户名
                trusted-users = [ "root" "carry" ];

                experimental-features = [ "nix-command" "flakes" ];     # 启用实验性功能：nix命令增强和flakes支持
                keep-outputs = true;  # 减少重复编译
                keep-derivations = true;
                download-buffer-size = 134217728;  # 默认较小，改为 64M 或 128M
              };
            })



            # 集成 Home Manager，并传递 stateVersion
            ({ config, lib, ... }: {
              imports = [ home-manager.nixosModules.home-manager ];
              home-manager.useGlobalPkgs = true;                      # 允许用户使用系统级pkgs
              home-manager.useUserPackages = true;                    # 启用用户专属包
              home-manager.users.carry = import ./home/home.nix {     # 关联用户Home配置（用户名为carry）
                inherit config lib pkgs;  # 传递home.nix需要的参数
                stateVersion = config.system.stateVersion;  # 传入系统版本
              };
            })
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



            # 全局 Nix 镜像配置（已加入：清华+中科大+官方）
            ({ config, lib, ... }: {
              nix.settings = {
                substituters = [
                  "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华
                  "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大
                  "https://cache.nixos.org/"  # 官方兜底
                ];
                # ✅ 已修正：仅保留官方公钥（清华/中科大无独立公钥）
                trusted-public-keys = [
                  # 官方源的公钥
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                ];

                # 关键：添加可信用户
                # 替换 "carry" 为你的实际用户名
                trusted-users = [ "root" "carry" ];

                experimental-features = [ "nix-command" "flakes" ];     # 启用实验性功能：nix命令增强和flakes支持
                keep-outputs = true;  # 减少重复编译
                keep-derivations = true;
                download-buffer-size = 134217728;  # 默认较小，改为 64M 或 128M
              };
            })



            # 集成 Home Manager（同上）
            ({ config, lib, ... }: {
              imports = [ home-manager.nixosModules.home-manager ];
              home-manager.useGlobalPkgs = true;                      # 允许用户使用系统级pkgs
              home-manager.useUserPackages = true;                    # 启用用户专属包
              home-manager.users.carry = import ./home/home.nix {     # 关联用户Home配置（用户名为carry）
                inherit config lib pkgs;  # 传递home.nix需要的参数
                stateVersion = config.system.stateVersion;  # 传入系统版本
              };
            })
          ];
        };
      };
    };
}
