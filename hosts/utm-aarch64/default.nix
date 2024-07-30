{ config, pkgs, ... }:

{
    imports =
        [
            ../../modules/system.nix
            ../../modules/i3.nix

            # Include the results of the hardware scan
            ./hardware-configuration.nix
        ];
    
    # Bootloader
    # Use the systemd-boot EFI boot loader
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    # Networking
    networking.hostName = "nixos-utm-aarch64";
    networking.networkmanager.enable = true;

    # Hardware options
    hardware.graphics.enable = true;

    # VM Guest Agent
    services.spice-vdagentd.enable = true;
    services.qemuGuest.enable = true;

    system.stateVersion = "24.05"; # leave for compatibility
}
