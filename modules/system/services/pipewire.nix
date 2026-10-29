{
  ...
}:

{
  # 音频服务（PipeWire替代PulseAudio）
  services.pulseaudio.enable = false; # 禁用旧的 PulseAudio 服务
  security.rtkit.enable = true; # 启用实时线程调度（低延迟音频必备）
  services.pipewire = {
    enable = true; # 核心：启用 PipeWire 主服务
    alsa.enable = true; # 兼容 ALSA 音频架构（Linux 基础音频）
    alsa.support32Bit = true; # 支持 32 位应用的 ALSA 兼容（如 Wine/游戏）
    pulse.enable = true; # 兼容 PulseAudio 协议（绝大多数桌面软件依赖）
    jack.enable = true; # 启用 JACK 兼容（专业音频软件/DAW 必备）
  };
}
