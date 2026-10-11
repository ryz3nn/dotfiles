{ config, pkgs, ... }:
{
  boot.kernelParams = [
    "radeon.si_support=0"
    "amdggpu.si_support=1"
  ];
  hardware.graphics = {
    enable  = true;
    enable32Bit = true;
  };
  boot.initrd.kernelModules = ["amdgpu"];
  }
