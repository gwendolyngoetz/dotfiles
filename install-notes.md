# Notes


## Install Tools

- network-manager  // for nmcli
- git


## Remove Snapd

```
sudo apt remove snapd
sudo apt purge snapd
```

Purged required or you get errors with AppArmor


## Disable Cloud init

```
sudo touch /etc/cloud/cloud-init.disabled
```

## Set timezone
```
sudo timedatectl set-timezone America/Los_Angeles
```

## Disable Wifi

Blacklisted module: iwlwifi

```
sudo printf "\n# 12/12/2021 Block wifi\nblacklist iwlwifi" | sudo tee -a /etc/modprobe.d/blacklist.conf
```

Removed wifi specific file from /etc/netplan directory

```
sudo netplan apply
```

## Disable Extra Ethernet Adapter

edit  /etc/netplan config to set unused eth adapter to 
  - optional=true
  - dhcp4=false
  - dhcp6=false


## Audio

```
sudo apt install alsa-utils
sudo usermod -aG audio $USER

sudo apt install pavucontrol
```


## Install i3

### Install build tools
```
sudo apt install gcc
sudo apt install make
sudo apt install meson
```

### Install dependency libraries
```
sudo apt install libxcb1-dev \
    libxcb-keysyms1-dev \
    libpango1.0-dev \
    libxcb-util0-dev \
    libxcb-icccm4-dev \
    libyajl-dev \
    libstartup-notification0-dev \
    libxcb-randr0-dev \
    libev-dev \
    libxcb-cursor-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    autoconf \
    libxcb-xrm0 \
    libxcb-xrm-dev \
    automake \
    libxcb-shape0-dev
```

### Clone Repository

```
cd ~/src/github
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
```

### Compile & Install

```
mkdir -p build && cd build
meson ..
ninja
sudo ninja install
```

### Install xorg

```
sudo apt install xorg
```


### Configure X session to use i3

```
echo "exec i3" >> ~/.xinitrc
```

### Test i3 runs
```
startx
```


## Load dotfiles 

### Clone repository

```
git clone --bare https://github.com/gwendolyngoetz/dotfiles.git $HOME/.dotfiles
```

### Define the config alias in the current shell scope

```
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### Checkout code
```
config checkout
```

### Hide Untracked Files

```
config config --local status.showUntrackedFiles no
```


## Install Alacritty
```
sudo add-apt-repository ppa:aslatter/ppa
sudo apt update
sudo apt install alacritty
```

## Install Firefox
```
sudo apt install firefox
```


## Install SDDM
```
sudo apt install sddm
sudo sddm --example-config | sudo tee -a /etc/sddm/sddm.conf
```


## Install Polybar

### Install Build Dependencies

```
sudo apt install cmake \
    cmake-data \
    pkg-config \
    python3 \
    python3-sphinx \
    python3-packaging
```

### Install Required Dependencies
```
sudo apt install build-essential \
    git \
    cmake \ 
    cmake-data \ 
    pkg-config \ 
    python3-sphinx \
    python3-packaging \
    libuv1-dev \
    libcairo2-dev \
    libxcb1-dev \
    libxcb-util0-dev \
    libxcb-randr0-dev \
    libxcb-composite0-dev \
    python3-xcbgen \
    xcb-proto \
    libxcb-image0-dev \
    libxcb-ewmh-dev \
    libxcb-icccm4-dev
```

### Install Optional Dependencies

```
sudo apt install libxcb-xkb-dev \
    libxcb-xrm-dev \
    libxcb-cursor-dev \
    libasound2-dev \
    libpulse-dev \
    i3-wm \
    libjsoncpp-dev \
    libmpdclient-dev \
    libcurl4-openssl-dev \
    libnl-genl-3-dev
```

### Clone Repository
```
cd ~/src/github
git clone --recursive https://github.com/polybar/polybar
cd polybar
```

### Compile
```
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install

```


## Install apps used by my i3 config
```
sudo apt install feh
sudo apt install dunst
sudo apt install solaar
sudo apt install flameshot
sudo apt install zenity
sudo apt install rofi

sudo apt install 
sudo apt install 

```


## Install apps used by my polybar scripts
```
sudo apt install jq
```

## Install xmenu
```
sudo apt install libxinerama-dev
sudo apt install libimlib2-dev


cd ~/src/github
git clone https://github.com/phillbush/xmenu.git
cd xmenu
make
make install
```


## Install apps used by other
```
sudo apt install libnotify-bin
```

## Install Spotify (from deb)
```
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 

echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt-get update && sudo apt-get install spotify-client
```

## Install obs

```
sudo apt install ffmpeg
```

### Install v4lsloopback
```
sudo apt install v4l2loopback-dkms
```

FIX FOR NOW

Download from https://packages.debian.org/sid/all/v4l2loopback-dkms/download
sudo modprobe -r v4l2loopback
sudo dpkg -i $HOME/Downloads/v4l2loopback-dkms_0.12.5-1_all.deb
sudo apt-mark hold v4l2loopback-dkms


sudo apt install mesa-utils  #for glxinfo

sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio
```


## Install other apps

```
sudo apt install zip
sudo apt install unzip
sudo apt install newsboat
sudo apt install virtualbox
sudo apt install htop
sudo apt install keepassx
sudo apt install virtualbox-ext-pack
sudo apt install meld
sudo apt install qt5ct
```


## Install dracula qt5 theme
```
git clone https://github.com/dracula/qt5.git ~/src/github/qt5-dracula-theme
cp ~/src/github/qt5-dracula-theme/Dracula.conf ~/.config/qt5ct/colors/
```


## Vim
```
mkdir ~/.vim
mkdir ~/.tmp
```
