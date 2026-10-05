# NixOS 配置操作流程

> 核心口诀：**格式化 → add → check → eval → rebuild**
> 五步走，出错就停，修完从失败那步继续。

---

## 一、一条龙命令

```bash
nix run nixpkgs#nixfmt -- $(find . -name '*.nix' -not -path './.git/*') \
  && git add -A \
  && nix flake check \
  && nix eval '.#nixosConfigurations.desktop.config.system.build.toplevel.drvPath' \
  && sudo nixos-rebuild switch --flake .#desktop
```

**任何一步失败就停**，修完再从失败那步继续。

---

## 二、分步说明

### 1. 格式化

```bash
nix run nixpkgs#nixfmt -- $(find . -name '*.nix' -not -path './.git/*')
```

统一所有 `.nix` 文件的格式。改了任何 `.nix` 文件后都要跑。

> 备注：新版 nixpkgs 里 `nixfmt-rfc-style` 已与 `nixfmt` 合并，用 `nixfmt` 即可。

### 2. git add

```bash
git add -A
```

**必须做**。flakes 只把 git 已跟踪的文件复制进 `/nix/store`，新文件和改动过的文件不 `git add` 的话，Nix 看不到。

不需要 commit，进 index 即可。

### 3. 质量检查

```bash
nix flake check          # 一次跑全部
```

或分开跑（定位更清晰）：

```bash
nix build .#checks.x86_64-linux.formatting
nix build .#checks.x86_64-linux.lint
nix build .#checks.x86_64-linux.dead-code
```

三个 check 分别校验：

| check | 工具 | 检查内容 |
|---|---|---|
| `formatting` | nixfmt | 格式是否统一 |
| `lint` | statix | 代码风格问题 |
| `dead-code` | deadnix | 未使用的参数/绑定 |

### 4. 求值验证（不构建，秒级）

```bash
nix eval '.#nixosConfigurations.desktop.config.system.build.toplevel.drvPath'
nix eval '.#nixosConfigurations.laptop.config.system.build.toplevel.drvPath'
```

**引号必须有**，否则 zsh 会把 `<host>` 当重定向。

成功输出一行 `/nix/store/xxx-nixos-system-nixos-...drv`。
失败会打印具体错误（模块、选项、import 等）。

**这一步不构建**，只求值，几秒钟就能抓到绝大多数问题。

### 5. 部署

```bash
# 首次部署、重大改动、怕挂：装到 bootloader，重启才生效
sudo nixos-rebuild boot --flake .#desktop

# 日常小改：立即激活
sudo nixos-rebuild switch --flake .#desktop

# 临时验证：激活但重启后回旧世代
sudo nixos-rebuild test --flake .#desktop
```

---

## 三、命令对照表

### `boot` vs `switch` vs `test`

| 命令 | 行为 | 何时用 |
|---|---|---|
| `boot` | 装到 bootloader，重启后生效 | 首次、重大改动、怕挂 |
| `switch` | 立即激活 | 日常小改 |
| `test` | 临时激活，重启回旧世代 | 快速验证，不留历史 |

### `eval` vs `build` vs `rebuild`

| 命令 | 做什么 | 耗时 |
|---|---|---|
| `nix eval ...drvPath` | 只求值，不构建 | 秒级 |
| `nix build ...` | 求值 + 构建 | 分钟级 |
| `nixos-rebuild boot` | 求值 + 构建 + 装 bootloader | 分钟级 |
| `nixos-rebuild switch` | 求值 + 构建 + 装 + 激活 | 分钟级 |

**先用 `eval` 抓求值错误，再用 `rebuild` 构建。**

---

## 四、常用工具命令

```bash
# 进开发环境（含 deadnix / nixfmt / statix 等）
nix develop

# 单独看某个 check 的完整日志
nix log /nix/store/xxx-check-xxx.drv

# 查看当前 flake 的 inputs 版本
nix flake metadata

# 查看当前 flake 输出的属性
nix flake show

# 列出所有系统世代
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# 回滚到上一个世代
sudo nixos-rebuild switch --rollback

# 更新所有 input
nix flake update

# 只更新指定 input
nix flake update noctalia
```

---

## 五、分场景流程

### A. 只改了几个小文件

```bash
nix run nixpkgs#nixfmt -- $(find . -name '*.nix' -not -path './.git/*')
git add -A
nix flake check
nix eval '.#nixosConfigurations.desktop.config.system.build.toplevel.drvPath'
sudo nixos-rebuild switch --flake .#desktop
```

### B. 重构了目录结构

```bash
git add -A
nix flake check
nix eval '.#nixosConfigurations.desktop.config.system.build.toplevel.drvPath'
nix eval '.#nixosConfigurations.laptop.config.system.build.toplevel.drvPath'
# 两台都过再部署
sudo nixos-rebuild boot --flake .#desktop
```

### C. 只改了一台机器的硬件配置

```bash
nix flake check
nix eval '.#nixosConfigurations.laptop.config.system.build.toplevel.drvPath'
sudo nixos-rebuild switch --flake .#laptop
```

### D. 改了 inputs

```bash
nix flake update              # 或 nix flake update <name>
git add -A
nix flake check
nix eval '.#nixosConfigurations.desktop.config.system.build.toplevel.drvPath'
sudo nixos-rebuild boot --flake .#desktop   # 首次建议 boot
```

### E. 求值报错，想看详细栈

```bash
nix eval '.#nixosConfigurations.desktop.config.system.build.toplevel.drvPath' --show-trace
```

---

## 六、错误排查手册

### `Path 'xxx' does not exist in Git repository`

**原因**：文件没进 git index，Nix 看不到。

**修**：`git add -A`

### `not formatted`

**原因**：文件没跑 nixfmt。

**修**：

```bash
nix run nixpkgs#nixfmt -- $(find . -name '*.nix' -not -path './.git/*')
```

### `Unused lambda pattern`

**原因**：函数参数没用到（deadnix 报）。

**修**：打开报错文件，把未使用参数从签名里删掉，或用 `{ ... }:`。

### `empty pattern in function argument`（statix）

**原因**：`{ ... }` 被 statix 误报。

**修**：确认 `statix.toml` 里禁用了 `empty_pattern`。

### `option 'xxx' does not exist`

**原因**：版本漂移，选项在新 nixpkgs 里改名或移除。

**修**：查选项新名字，或看 nixpkgs changelog。

### `Package 'xxx' has an unfree license`

**原因**：需要 unfree 包但没开。

**修**：`mkHost` 的 modules 里加：

```nix
{ nixpkgs.config.allowUnfree = true; }
```

### `appimage-run` 缺库（`libxxx.so.N: cannot open shared object file`）

**原因**：AppImage 运行环境缺库。

**修**：在 `programs.appimage.package` 里加 `extraPkgs`：

```nix
package = pkgs.appimage-run.override {
  extraPkgs = pkgs: with pkgs; [
    libepoxy
    libxshmfence
    libsoup_3
    webkitgtk_4_1
    libnotify
    # 遇到缺什么加什么
  ];
};
```

### `eval-cache-*.sqlite is busy`

**原因**：并行跑多个 Nix 命令，缓存锁竞争。

**处理**：**忽略**。Nix 自己会绕过缓存继续求值。

### SSL connect error（cache.nixos.org 等）

**原因**：二进制缓存服务器网络抖动。

**处理**：Nix 会自动重试。若最终失败，包会从源码构建（慢但能成功）。重跑一次通常就好。

---

## 七、项目特定信息

- **两个 host**：`desktop`、`laptop`
- **检查命令**：`nix build .#checks.x86_64-linux.{formatting,lint,dead-code}`
- **求值命令**：`nix eval '.#nixosConfigurations.<host>.config.system.build.toplevel.drvPath'`（引号必须有）
- **statix 配置**：`statix.toml` 禁用了 `empty_pattern`
- **部署**：`sudo nixos-rebuild {boot,switch} --flake .#<host>`

---

## 八、理念：为什么是这个顺序

1. **格式化在最前**：改了文件马上格式化，避免后续 check 报一堆格式问题干扰真问题。
2. **`git add` 在 check 之前**：确保 Nix 能看到所有文件。
3. **check 在 eval 之前**：check 快，先过滤风格/死代码问题；eval 慢一些，留给真正的语义错误。
4. **eval 在 rebuild 之前**：eval 秒级，rebuild 分钟级。先用 eval 抓错，省时间。
5. **首次部署用 boot**：万一新配置起不来，重启选旧世代，风险最低。

---

## 九、出错时就停

这条最重要：**任何一步失败，不要继续往下**。

- 格式没对 → 继续 check 只会报更多无关错误
- check 没过 → 继续 eval 可能能过，但反正要回来修
- eval 没过 → rebuild 一定也过不了

**修完从失败那步继续**，不要跳步。

---

*最后更新：2026-10-05*
