
{ config, pkgs, ... }: {
  programs.niri.enable = true;

  security.polkit.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
  }
