{ config, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.amdgpu.legacySupport.enable = true;
}
