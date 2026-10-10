{ pkgs, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      # Runs every hour at minute 0 as your user
      "*/5 * * * * derek ${pkgs.bash}/bin/bash /home/derek/dotfiles/scripts/auto_push.sh"
    ];
  };
}
