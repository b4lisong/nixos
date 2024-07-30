{
    pkgs,
    lib,
    ...
}: let
    username = "balisong";
in {
    # User related config

    # Define a user account (don't forget to set a password with `passwd`!)
    users.users.balisong = {
        isNormalUser = true;
        description = "balisong";
        extraGroups = [ "networkmanager" "wheel" ];
        # TODO: add pubkeys with
        # openssh.authorizedKeys.keys = [ "" ];
    };
    
    # Use zsh as default shell
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Customize /etc/nix/nix.conf declaratively via `nix.settings`
    nix.settings = {
        # enable flakes globally
        experimental-features = [ "nix-command" "flakes" ];
    };

    # Weekly garbage collection to keep disk usage low
    nix.gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 7d";
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Time zone
    time.timeZone = "America/Los_Angeles";

    # Set locale
    i18n.defaultLocale = "en_US.UTF-8";

    # Enable CUPS for printing
    services.printing.enable = true;

    # Fonts
    fonts = {
        packages = with pkgs; [
            # icon fonts
            material-design-icons
            
            # normal fonts
            noto-fonts
            noto-fonts-cjk
            noto-fonts-emoji

            # nerdfonts
            (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
        ];

        # use user-specified fonts rather than default ones
        enableDefaultPackages = false;

        # user defined fonts
        # the reason there's Noto Color Emoji everywhere is to override DejaVu's
        # B&W emojis that would sometimes show instead of some Color emojis
        fontconfig.defaultFonts = {
            serif = ["Noto Serif" "Noto Color Emoji"];
            sansSerif = ["Noto Sans" "Noto Color Emoji"];
            monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
            emoji = ["Noto Color Emoji"];
        };
    };

    # Enable dconf
    programs.dconf.enable = true;

    # Firewall settings
    networking.firewall.enable = false;

    # OpenSSH daemon
    services.openssh = {
        enable = true;
        settings = {
            X11Forwarding = true;
            PermitRootLogin = "no";
            PasswordAuthentication = true; # TODO: disable
        };
        openFirewall = true;
    };

    # System (accessible as root) packages
    environment.systemPackages = with pkgs; [
        vim
        wget
        curl
        git
        sysstat
        lm_sensors # for `sensors` command
        neofetch
        scrot
        xfce.thunar
        ranger
    ];

    # Enable polkit
    security.polkit.enable = true;

    # Enable power-profiles-daemon service
    services.power-profiles-daemon.enable = true;

    # Enable sound with pipewire - disable pulseaudio default
    hardware.pulseaudio.enable = false;
    
    # Enable additional services
    services = {
        dbus.packages = [pkgs.gcr];

        geoclue2.enable = true;

        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
        };

        udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    };
}
