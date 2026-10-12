{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true; # Configures v4l2loopback & polkit rules automatically

    # Optional: Enable Nvidia NVENC hardware acceleration
    # package = pkgs.obs-studio.override { cudaSupport = true; };

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs                      # Screen capture on wlroots-based compositors (Sway, Hyprland)
      obs-pipewire-audio-capture  # PipeWire audio stream capturing
      obs-vkcapture               # Direct Vulkan/OpenGL capture (ideal for games)
      obs-vaapi                   # VA-API hardware encoding for Intel/AMD GPUs
      obs-gstreamer               # GStreamer pipelines support
      obs-backgroundremoval       # AI-based background removal
    ];
  };
}
