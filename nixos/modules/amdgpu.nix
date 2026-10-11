{ config, pkgs, ... }:
{
  boot.kernelParams = [
    "radeon.si_support=0"
    "amdgpu.si_support=1"
    "radeon.cik_support=0"
    "amdgpu.si_support=1"
  ];

  hardware.graphics = {
    enable  = true;
    enable32Bit = true;
    };
  }
