{ config, pkgs, ... }:
{
  hardware.graphics = {
    enable  = true;
    enable32Bit = true;
  };
  boot.kernelParams = [
    "radeon.si_support=0"
    "amdgpu.si_support=1"
  ];
  boot.kernelModules = ["amdgpu"];
  }
