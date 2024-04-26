{ config, pkgs, ... }:

{
  imports =
    [ <nixos-hardware/lenovo/thinkpad/x1/11th-gen>
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "satsuki";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_CA.UTF-8";
    LC_IDENTIFICATION = "en_CA.UTF-8";
    LC_MEASUREMENT = "en_CA.UTF-8";
    LC_MONETARY = "en_CA.UTF-8";
    LC_NAME = "en_CA.UTF-8";
    LC_NUMERIC = "en_CA.UTF-8";
    LC_PAPER = "en_CA.UTF-8";
    LC_TELEPHONE = "en_CA.UTF-8";
    LC_TIME = "en_CA.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # exclusions from plasma
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      mesa_drivers
      intel-media-driver
      intel-ocl
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  nix.settings = {
    auto-optimise-store = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  users.defaultUserShell = pkgs.zsh; 
  
  users.users.maru = {
    isNormalUser = true;
    description = "Matilde Park";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      firefox-devedition
      thunderbird
      discord
      strawberry
      signal-desktop-beta
      vscode-fhs
      (appimageTools.wrapType2 {
        name = "everdo";
        src = fetchurl {
        url = "https://release.everdo.net/1.9.0/Everdo-1.9.0.AppImage";
        hash = "sha256-0yxAzM+qmgm4E726QDYS9QwMdp6dUcuvjZzWYEZx7kU=";
        };
      })
      nicotine-plus
      jrnl
      clematis
      woeusb-ng
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
   bash
   vim
   wget
   python3
   nodejs
   wineWowPackages.stable
   fprintd
   figma-linux
   figma-agent
   bitwig-studio
   keeweb
   gh
   cabextract
   samba4Full
   krb5
   winetricks
   renpy
   unrar
   devilutionx
   libsForQt5.kdeconnect-kde
   google-chrome
   google-drive-ocamlfuse
  ];

  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  fonts.packages = with pkgs; [
    corefonts
    source-code-pro
    mplus-outline-fonts.githubRelease
    (iosevka-bin.override { variant = "Aile"; })
    inter
  ];

  # programs
  programs.steam.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      sysconfig = "sudo vim /etc/nixos/configuration.nix";
      update = "sudo nixos-rebuild switch";
    };
  };
  programs.git = {
    enable = true;
  };
  
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;

  networking.firewall.allowedTCPPortRanges = [ {
    from = 1714; to = 1764;
  } ];
  networking.firewall.allowedUDPPortRanges = [ {
    from = 1714; to = 1764;
  } ];

  system.stateVersion = "23.11";
}
