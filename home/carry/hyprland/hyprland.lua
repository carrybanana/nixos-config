-- 这是 Hyprland 的 Lua 配置示例文件
-- 更多用法详见官方文档：https://wiki.hypr.land/Configuring/Start/
-- 注意：这里没有列出所有可用选项，完整列表请查看文档
-- 你可以（也应该）将配置拆分成多个文件
-- 单独创建文件后像这样引入：require("myColors")

------------------
---- 显示器配置 ----
------------------
-- 文档：https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",          -- 显示器名称（留空自动识别）
    mode     = "preferred", -- 分辨率：使用首选
    position = "auto",      -- 位置：自动
    scale    = 1,      -- 缩放：自动
})

---------------------
---- 常用程序定义 ----
---------------------
-- 在这里设置你常用的软件
local terminal    = "kitty"      -- 终端
local fileManager = "dolphin"    -- 文件管理器
local menu        = "hyprlauncher"-- 应用启动器

-------------------
---- 开机自启动 ----
-------------------
-- 文档：https://wiki.hypr.land/Configuring/Basics/Autostart/
-- 自启动必要进程（如通知服务、状态栏等）
-- 或开机直接运行你喜欢的应用
hl.on("hyprland.start", function ()
    hl.exec_cmd("fcitx5 -d")  	-- 后台启动 fcitx5（-d = daemon）

--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
end)

-------------------------------
---- 环境变量设置 ----
-------------------------------
-- 文档：https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")    -- 系统光标大小
hl.env("HYPRCURSOR_SIZE", "24")  -- Hyprland 光标大小

-----------------------
----- 权限配置 -----
-----------------------
-- 文档：https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- 注意：权限修改需要重启 Hyprland 才生效，无法热重载（安全原因）
-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- 外观与视觉 ----
-----------------------
-- 文档：https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,     -- 窗口内部间距
        gaps_out = 20,    -- 窗口外部间距
        border_size = 2,  -- 边框大小
        col = {
            -- 激活窗口边框：渐变
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
          inactive_border = "rgba(595959aa)", -- 未激活窗口边框
        },
        -- 是否允许通过拖拽边框/间隙调整窗口大小
        resize_on_border = false,
        -- 开启前请阅读：https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
        allow_tearing = false,
        layout = "scrolling", -- 默认布局：scrolling
    },
    decoration = {
        rounding       = 10,  -- 窗口圆角
        rounding_power = 2,   -- 圆角强度
        -- 窗口透明度
        active_opacity   = 1.0,  -- 激活窗口
        inactive_opacity = 1.0,  -- 未激活窗口
        shadow = { -- 窗口阴影
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = { -- 毛玻璃效果
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },
    animations = {
        enabled = true, -- 开启动画
    },
})

-- 动画曲线预设，文档：https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
-- 弹性动画
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

-- 全局动画参数
hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- 智能间距：仅一个窗口时无边距（取消注释启用）
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- Dwindle 布局设置
hl.config({
    dwindle = {
        preserve_split = true, -- 保留分割结构（建议开启）
    },
})

-- Master 布局设置
hl.config({
    master = {
        new_status = "master", -- 新窗口默认成为主窗口
    },
})

-- Scrolling 布局设置
hl.config({
    scrolling = {
        fullscreen_on_one_column = true, -- 单列时全屏
    },
})

----------------
---- 杂项设置 ----
----------------
hl.config({
    misc = {
        force_default_wallpaper = -1,    -- -1=默认；0/1=关闭动漫吉祥物壁纸
            disable_hyprland_logo   = false, -- 是否关闭 Hyprland logo/动漫背景
    },
})

---------------
---- 输入设备 ----
---------------
hl.config({
    input = {
        kb_layout  = "us",      -- 键盘布局
        kb_variant = "",        -- 键盘变体
        kb_model   = "",        -- 键盘型号
        kb_options = "",        -- 键盘选项
        kb_rules   = "",        -- 键盘规则
        follow_mouse = 1,       -- 焦点跟随鼠标
        sensitivity = 0,        -- 鼠标灵敏度：-1.0~1.0，0=不修改
        touchpad = {
            natural_scroll = false, -- 自然滚动
        },
    },
})

-- 三指水平滑动：切换工作区
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- 单设备配置示例
-- hl.device({
--     name        = "epic-mouse-v1",
--     sensitivity = -0.5,
-- })

---------------------
---- 快捷键绑定 ----
---------------------
local mainMod = "SUPER" -- 主修饰键：Win键

-- ======================
-- 布局切换 终极修复版（纯Lua原生，零报错）
-- ======================
-- 切换到 Dwindle 布局
hl.bind(mainMod .. " + ALT + D", function()
    hl.config({ general = { layout = "dwindle" } })
end)

-- 切换到 Master 布局
hl.bind(mainMod .. " + ALT + M", function()
    hl.config({ general = { layout = "master" } })
end)

-- 切换到 Scrolling 滚动布局
hl.bind(mainMod .. " + ALT + S", function()
    -- 用完整配置写入方式，彻底规避 layoutmsg 找不到的问题
    hl.config({ general = { layout = "scrolling" } })
end)

-- 基础快捷键
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal)) -- 打开终端
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close()) -- 关闭窗口
-- closeWindowBind:set_enabled(false) -- 禁用此快捷键

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")) -- 退出会话
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager)) -- 文件管理器
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" })) -- 切换窗口浮动
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu)) -- 打开启动器
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- 伪平铺/伪浮动
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- 切换分割方向（仅dwindle）

-- 方向键切换焦点
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- 数字键切换工作区 / Shift+数字 移动窗口到工作区
for i = 1, 10 do
    local key = i % 10 -- 10对应0键
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- 专用工作区（scratchpad）
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic")) -- 呼出/隐藏专用工作区
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" })) -- 窗口移入专用工作区

-- 鼠标滚轮切换工作区
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- 拖拽/调整窗口：Win+鼠标左键拖拽、Win+鼠标右键调整大小
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- 笔记本多媒体键：音量、亮度
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- 音乐控制（需安装 playerctl）
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

--------------------------------
---- 窗口与工作区规则 ----
--------------------------------
-- 文档：https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- 文档：https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- 全局禁止应用最大化（非常实用）
local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false) -- 关闭此规则

-- 修复 XWayland 应用拖拽问题
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- hyprland-run 窗口定位
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
