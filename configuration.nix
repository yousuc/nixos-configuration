# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running â€˜nixos-helpâ€™).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "mitigations=off"
    "quiet"
  ];

  networking.hostName = "ficsit"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
#      xdg-desktop-portal-gtk
    ];
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

  # Define a user account. Don't forget to set a password with â€˜passwdâ€™.
  users.users.james = {
    isNormalUser = true;
    description = "James Ireland";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  firefox
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
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    acpi
    acpid
    alacritty
    autojump
    bash-completion
    bat
    brave
    btop
    clang
    curl
    gnome.dconf-editor
    dig
    directx-headers
    discord
    dunst
    evolution
    filezilla
    firefox-devedition
    fontconfig
    font-awesome
    freetype
    gcc
    geoip
    gimp
    git
    github-desktop
    glibc
    gnome.gnome-tweaks
    gnomeExtensions.arcmenu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.openweather
    gnomeExtensions.vitals
    gnumake
    gtk_engines
    gtk-engine-murrine
    heroic
    hplip
    imagemagick
    inetutils
    kitty
    libappindicator
    libreoffice-fresh
    librewolf
    lm_sensors
    lsd
    lynx
    mesa
    meson
    neofetch
    neovim
    nerd-font-patcher
#    nerdfonts
    ninja
    papirus-icon-theme
    pipx
    pkgconfig
    powerline
    powerline-fonts
    python3Full
    python-launcher
    stdenv
    starship
    steam
    steam-run
    sublime4
    tldr
    udev
    unzip
    usbmuxd2
    vkd3d
    vkd3d-proton
    vscode
    vulkan-tools
    w3m
    wget
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

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.acpid.enable = true;
  services.dbus.enable = true;
  services.locate = {
    enable = true;
  };

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec = 10s
    '';
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Itâ€˜s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "23.05"; # Did you read the comment?
  system.stateVersion = "unstable";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
}
