{ config, pkgs, ... }:
{
  hardware.graphics = {
    enable  = true;
    enable32Bit = true;
    };
  hardware.amdgpu.legacySupport.enable = true;
  boot.initrd.kernelModules = ["amdgpu"];
  }
