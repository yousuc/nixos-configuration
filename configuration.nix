# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u"
  ];

  nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "steam" ]);

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Uncomment below for iPhone/iPad usb tethering
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.james = {
    isNormalUser = true;
    description = "James Ireland";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow <username> sudo without password
  security.sudo.extraRules= [
    {
      users = [ "james" ];
      commands = [
        { command = "ALL" ;
          options= [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    autojump
    bash-completion
    bat
    brave
    btop
    clang
    curl
    dig
    discord
    dracula-theme
    dunst
    dwm
    evolution
    filezilla
    firefox-devedition
    fontconfig
    font-awesome
    freetype
    gcc
    gdk-pixbuf
    gdk-pixbuf-xlib
    geoip
    gimp
    git
    github-desktop
    glibc
    gnome-icon-theme
    gnumake
    hplip
    imagemagick
    inetutils
    lf
    libappindicator-gtk3
    libimobiledevice
    libreoffice-fresh
    librewolf
    lm_sensors
    lsd
    lutris
    lynx
    meson
    mpv
    mutt-wizard
    neofetch
    neovim
    nerd-font-patcher
    nerdfonts
    newsboat
    ninja
    nordic
    papirus-icon-theme
    pipx
    pkgconfig
    poppler
    powerline
    python3Full
    snixembed
    stdenv
    starship
    steam
    steam-run
    sublime4
    tldr
    tsduck
    udev
    unzip
    usbmuxd2
    vkd3d
    vkd3d-proton
    vscode
    w3m
    wget
    xorg.libX11
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinput
    xorg.xinit
    (lutris.override {
      extraPkgs = pkgs: [
        wineWowPackages.stable
        winetricks
      ];
    })
    zathura
    zip
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
 
  #nixpkgs.overlays = [
  #  (final: prev: {
  #    dwm = prev.dwm.overrideAttrs (old: { src = /home/james/.github/dwm ;});
  #  })
  #];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font Mono Regular" ];
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
      };
    };
  };

  # List services that you want to enable:
  # DBus
  services.dbus.enable = true;
  services.locate = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
}
