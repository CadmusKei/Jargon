{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "headnode";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "za";
    variant = "";
  };

  users.users."sysAdmin" = {
   isNormalUser = true;
    description = "system adminstrator for HPC Cluster";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    initialPassword = "wasd";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKrF+siRa7198mKVcgE/5+Da7rChaDkj116DjnEiWAy/ kei@Trisium"
    ];
  };

  security.sudo.extraRules = [
    {
      users = [ "sysAdmin" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  nixpkgs.config.allowUnfree = true;


  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     btop
  ];

  programs.git.enable = true;

  environment.enableAllTerminfo = true;
  environment.shellAliases = {
    nc = "sudo nano /etc/nixos/configuration.nix";
    nrs = "sudo nixos-rebuild switch";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "26.05";

}
