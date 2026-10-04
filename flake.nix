{
  description = "系统配置";
  inputs = {
    #     nixpkgs.url = "github:NixOS/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #     nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:

    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      hosts = import ./hosts/inventory.nix;
      username = "carry";
      homeModules = [ ./home/carry/default.nix ];
      #     mkHomeSpecialArgs = { inherit inputs; };
      src = lib.cleanSource ./.;

      mkHost =
        name: host:
        lib.nixosSystem {
          inherit (host) system;
          specialArgs = {
            inherit inputs username;
          };
          modules = [
            ./hosts/${name}/configuration.nix
            ./hosts/${name}/hardware-configuration.nix
            ./modules/default.nix
            inputs.impermanence.nixosModules.impermanence
            inputs.agenix.nixosModules.age
            inputs.catppuccin.nixosModules.catppuccin
            inputs.home-manager.nixosModules.home-manager

            {
              environment.systemPackages = [
                inputs.agenix.packages.${host.system}.agenix
              ];

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs username;
              };
              home-manager.users.${username} = {
                imports = homeModules;
              };
            }

            # 把当前 flake commit hash 写进系统，世代号旁能看到配置版本
            ({ ... }: {
              system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
            })
          ];
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ system ];

      flake = {
        nixosConfigurations = lib.concatMapAttrs (name: host: {
          "${name}" = mkHost name host;
        }) hosts;
      };

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt;

        packages.home-manager =
          inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager;

        devShells.default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            deadnix
            jq
            nixfmt
            ripgrep
            shellcheck
            statix
          ];
        };

        checks = {
          formatting =
            pkgs.runCommand "check-formatting"
              {
                nativeBuildInputs = [ pkgs.nixfmt ];
              }
              ''
                nixfmt --check $(find ${src} -name '*.nix' -type f)
                touch $out
              '';

          lint =
            pkgs.runCommand "check-lint"
              {
                nativeBuildInputs = [ pkgs.statix ];
              }
              ''
                statix check --config ${src}/statix.toml ${src}
                touch $out
              '';

          dead-code =
            pkgs.runCommand "check-dead-code"
              {
                nativeBuildInputs = [ pkgs.deadnix ];
              }
              ''
                deadnix --fail ${src}
                touch $out
              '';
        };
      };
    };
}
