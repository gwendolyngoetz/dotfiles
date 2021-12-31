# Notes


## Install Tools

```
sudo apt install ansible
ansible-galaxy collection install community.general

sudo apt install exa
sudo apt install git
sudo apt install network-manager  // for nmcli
sudo apt install vim
```

## Fix Partition Size

### Check freespace
```
df -h
Filesystem                         Size  Used Avail Use% Mounted on
/dev/mapper/ubuntu--vg-ubuntu--lv  196G  143G   44G  77% /
```

### Resize the logical volume
```
sudo lvm
lvm> lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
lvm> exit
```

### Resize the file system
```
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv

resize2fs 1.44.1 (24-Mar-2018)
Filesystem at /dev/mapper/ubuntu--vg-ubuntu--lv is mounted on /; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 58
The filesystem on /dev/mapper/ubuntu--vg-ubuntu--lv is now 120784896 (4k) blocks long.
```

### Verify freespace
```
$ df -h

Filesystem                         Size  Used Avail Use% Mounted on
/dev/mapper/ubuntu--vg-ubuntu--lv  915G  143G  734G  17% /
```

## Remove Snapd

```
sudo apt remove snapd
sudo apt purge snapd
```

Purge required or you get errors with AppArmor


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


## Disable Extra Ethernet Adapter

```
sudo vim /etc/netplan/00-installer-config.yaml
```

Change the renderer to NetworkManager and make enp7s0 optional
  - optional=true
  - dhcp4=false
  - dhcp6=false


### Sample
```
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    enp6s0:
      dhcp4: true
    enp7s0:
      dhcp4: false
      dhcp6: false
      optional: true
```

### Regenerate netplan 
```
sudo netplan apply
```


## Audio

```
sudo apt install pavucontrol
sudo apt install alsa-utils
sudo usermod -aG audio $USER
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


## Configure SDDM

### Install SDDM
```
sudo apt install sddm
sudo sddm --example-config | sudo tee -a /etc/sddm.conf
```

### Get SDDM Theme
```
git clone https://github.com/MarianArlt/sddm-chili.git ~/src/github/sddm-chili

sudo mkdir /usr/share/sddm/themes/chili
cd ~/src/github/sddm-chili
rsync -av --exclude=".*" . /usr/share/sddm/themes/chili
```

Need to fix the perms too

### Set SDDM Theme

```
sudo vim /etc/sddm.conf
```

Find [Theme] section set current theme to chili

```
[Theme]
Current=chili
```

### Install theme dependencies

```
sudo apt install -y qml-module-qtquick-controls
sudo apt install -y qml-module-qtquick-controls2
```

### Set perms for user icon

```
ln -s ~/.face ~/.face.icon

setfacl -m u:sddm:x /home/username
setfacl -m u:sddm:r /home/username/.face.icon
```

### Test SDDM
```
 sddm-greeter --test-mode --theme /usr/share/sddm/themes/chili
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
sudo apt install flameshot
sudo apt install thunar
sudo apt install wmctrl
sudo apt install zenity
```

### Install dunst

Ubuntu package is too old

```
sudo apt install libdbus-1-dev
sudo apt install libglib2.0-dev
sudo apt install libgtk2.0-dev
sudo apt install libnotify-dev
sudo apt install libpango1.0-dev
sudo apt install libx11-dev
sudo apt install libxdg-basedir-dev
sudo apt install libxinerama-dev
sudo apt install libxrandr-dev
sudo apt install libxss-dev

git clone https://github.com/dunst-project/dunst.git
cd dunst
make WAYLAND=0 SYSTEMD=0 SYSCONFDIR=/etc/xdg
sudo make WAYLAND=0 SYSTEMD=0 SYSCONFDIR=/etc/xdg install

# TO REMOVE
#sudo make WAYLAND=0 SYSTEMD=0 SYSCONFDIR=/etc/xdg uninstall-purge
```


### Install rofi

Ubuntu package is too old

```
sudo apt install bison
sudo apt install flex

cd ~/src/github/system-repos
git clone --recursive https://github.com/davatorium/rofi.git
cd rofi
autoreconf -i
mkdir build && cd build

../configure --disable-check
make
sudo make install
```


### Install solaar
```
sudo add-apt-repository ppa:solaar-unifying/stable
sudo apt-get update

sudo apt install solaar
```

## Install apps used by my Polybar scripts
```
sudo apt install jq
```
### Set values in .profile
Need to add the AIRNOW values in .profile for the air quality api


## Install xmenu

### Install depencendies
```
sudo apt install libxinerama-dev
sudo apt install libimlib2-dev
```

### Compile xmenu
```
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

## Install OBS Studio

### Install dependencies

```
sudo apt install ffmpeg
```

### Install v4lsloopback

<!--
```
sudo apt install v4l2loopback-dkms
```
-->

<pre><code><del>sudo apt install v4l2loopback-dkms</del></code></pre>
#### FIX FOR NOW

Currently the package on Ubuntu has issues when trying to start again. Download from https://packages.debian.org/sid/all/v4l2loopback-dkms/download

```
sudo modprobe -r v4l2loopback

sudo dpkg -i $HOME/Downloads/v4l2loopback-dkms_0.12.5-1_all.deb
sudo apt-mark hold v4l2loopback-dkms
```

### Install OBS Studio
```
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio
```

## Install Streamdeck

### Install dependencies
```
sudo apt install python3-pip
sudo apt install libhidapi-libusb0
sudo apt install libxcb-xinerama0
```

### Install Streamdeck
```
sudo vim /etc/udev/rules.d/70-streamdeck.rules
```

Paste in
```
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", TAG+="uaccess"
```

```
sudo udevadm control --reload-rules
pip3 install --user streamdeck_ui

```


## Install other apps

```
sudo apt install darktable
sudo apt install fd-find
sudo apt install gimp
sudo apt install htop
sudo apt install keepassxc
sudo apt install libreoffice
sudo apt install lxappearance
sudo apt install meld
sudo apt install mesa-utils  #for glxinfo
sudo apt install neofetch
sudo apt install newsboat
sudo apt install qt5ct
sudo apt install thunar
sudo apt install tmux
sudo apt install ttf-mscorefonts-installer
sudo apt install unzip
sudo apt install virtualbox
sudo apt install virtualbox-ext-pack
sudo apt install xsel
sudo apt install youtube-dl
sudo apt install zip
```

### Install bat

Create a symlink because of Ubuntu conflict

```
sudo apt install bat
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
```


## Install and configure pass

### Install pass
```
sudo apt install pass
sudo apt install pass-extension-otp
```

### Configure pass
```
gpg --full-gen-key
pass init $USER
pass git init
pass generate test 10
```

### Configure and use pass otp (optional)
```
pass otp insert -e work
pass otp work
pass otp work --clip
```


## Install dracula qt5 theme
```
git clone https://github.com/dracula/qt5.git ~/src/github/qt5-dracula-theme
cp ~/src/github/qt5-dracula-theme/Dracula.conf ~/.config/qt5ct/colors/
```

## Install breeze gtk theme
```
sudo apt install breeze-gtk-theme
sudo apt install breeze-icon-theme
sudo apt install breeze-cursor-theme
```

## Vim
```
mkdir ~/.vim
mkdir ~/.tmp

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +PluginInstall +qall
```


## Install VSCode

### Setup apt
```
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/

sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

rm -f packages.microsoft.gpg
```

### Install VS Code

```
sudo apt update
sudo apt install code
```


## Install dev headers
```
sudo apt install libssl-dev
```


## Symlink theme related folders so sudo'd apps get themes
```
sudo ln -s ~/.themes /root/.themes
sudo ln -s ~/.fonts /root/.fonts
sudo ln -s ~/.icons /root/.icons
```

## Install Segoe Fonts
```
cd ~/src/github/tools
git clone https://github.com/mrbvrz/segoe-ui-linux.git
cd ./segoe-ui-linux/font
cp *.ttf ~/.fonts
sudo fc-cache -fv
```

## Install Neovim

Add notes here

## Install Docker

Use ansible playbook

## Programming Languages

### Dotnet

Use latest version

```
sudo apt-get install dotnet-sdk-6.0
```

### Nodejs

```
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt-get install -y nodejs
```