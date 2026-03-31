{ config, pkgs, lib, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
        # ========== 核心系统库 ==========
        stdenv.cc.cc zlib zstd curl openssl xz bzip2
        libxml2 libsodium systemd util-linux attr acl

        # ========== 基础图形界面 (所有桌面软件通用) ==========
        glib gtk2 gtk3 pango cairo atk gdk-pixbuf
        fontconfig freetype expat dbus

        # ========== X11 窗口系统 ==========
        libx11 libxext libxfixes libxrender libxcursor libxi
        libxrandr libxinerama libxtst libxcomposite libxdamage
        libxcb libxshmfence libxxf86vm

        # ========== 显卡 / 3D / 渲染 ==========
        libGL libGLU vulkan-loader libdrm libgbm libva libvdpau
        libepoxy

        # ========== 音频 ==========
        pipewire pulseaudio alsa-lib

        # ========== AppImage 必备 (fuse) ==========
        fuse e2fsprogs

        # ========== 游戏 / Steam / Unity ==========
        SDL2 SDL2_mixer SDL2_ttf ffmpeg libunwind
        glew_1_10 libogg libvorbis

        # ========== 网络 / 安全 ==========
        gnutls krb5 brotli libcap

        # ========== 常用第三方软件依赖 ==========
        webkitgtk_4_1 libsoup_3 harfbuzz
        libnotify icu libarchive
        libxkbcommon # Blender
    ];
  };

}
