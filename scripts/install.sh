#!/bin/bash


# Install dependencies
dependencies () {
sudo apt update
sudo apt install -y sudo apt install -y libxft-dev libxinerama1 libxinerama-dev # Dwm
}
# Install apps
misc () {
sudo apt update
sudo apt install -y gcc make apt-transport-https gpg  stow picom zsh gdebi sxhkd feh 
}

update_permission () {
chsh -s $(which zsh)

git config --global user.email "cklove2211@gmail.com"
git config --global user.name "derek"
git remote set-url --delete origin https://github.com/ryz3nn/dotfiles.git
git remote set-url --add origin git@github.com:ryz3nn/dotfiles
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
}
# Function 
update_folder () {
  cd 
  rm -rf Desktop Documents Downloads Music Pictures Public Templates Videos
  rm *.desktop
  mkdir downloads
  echo "Folder has been update"
}

dwm () {
cd $HOME/dotfiles/suckless/dwm/
sudo make clean install
cd $HOME/dotfiles/suckless/dmenu/
sudo make clean install
cd $HOME/dotfiles/suckless/st/
sudo make clean install
cd $HOME/dotfiles/suckless/slstatus/
sudo make clean install

sudo echo "
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic Window Manager
Exec=/usr/local/bin/dwm
Type=XSession
" >> /usr/share/xsessions/dwn.desktop
}

thorium-browser () {
sudo rm -fv /etc/apt/sources.list.d/thorium.list && \
sudo wget --no-hsts -P /etc/apt/sources.list.d/ \
http://dl.thorium.rocks/debian/dists/stable/thorium.list && \
sudo apt update

sudo apt install thorium-browser
}

firefox () {
sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla
sudo apt update && sudo apt install firefox
}

stretchly () {
cd $HOME/downloads 
wget https://github.com/hovancik/stretchly/releases/download/v1.17.2/Stretchly_1.17.2_amd64.deb
sudo gdebi Stretchly_1.17.2_amd64.deb

sudo sysctl kernel.unprivileged_userns_clone=1
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
sudo chmod 4755 /opt/Stretchly/chrome-sandbox
}


ibus () {
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo
sudo apt-get update
sudo apt-get install -y ibus ibus-bamboo --install-recommends

ibus-daemon -d
ibus restart

env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"
}

subl() {
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text
}

code () {
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install code # or code-insiders
}

VBoxManage () {
cd $HOME/downloads
wget https://download.virtualbox.org/virtualbox/7.1.8/virtualbox-7.1_7.1.8-168469~Ubuntu~noble_amd64.deb 
sudo gdebi virtualbox-7.1_7.1.8-168469~Ubuntu~noble_amd64.deb
}

burp () {
cd $HOME/downloads 
if [ ! -e "$HOME/downloads/burp.sh" ]; then
  wget "https://portswigger.net/burp/releases/download?product=community&version=2025.3.3&type=Linux" -O burp.sh
fi
chmod +x burp.sh
./burp.sh
}

# App need to install

normal_apps=(
  dwm
  thorium-browser
  firefox
  ibus
  stretchly
#  subl
  code
  VBoxManage
  burp
)

extra_apps=(

)

is_normal_installed () {
  which $1 &>/dev/null
}
install_normal_app () {
for app in ${normal_apps[@]}; do
  if is_normal_installed $app; then
    echo "$app is already installed"
  else 
    echo "$app is missing. Start installing $app ..."
    $app
  fi
done
}

# Entrance

case "$1" in 
  "-p")
    update_permission && echo "Permission has been updated"
  ;;
  "-f")
    update_folder &>/dev/null && echo "Folder has been updated"
  ;;
  "-a")
    install_normal_app 
  ;;
  "-d")
    dependencies    
  ;;
  "-m")
    misc    
  ;;
  "--full")
    update_folder &>/dev/null && echo "Folder has been updated"
    dependencies    
    misc    
    update_permission && echo "Permission has been updated"
    install_normal_app 
  ;;


  *)
    echo "
 -p : permission (zsh and github ssh)
 -f : remove and update folder
 -d : install dependencies
 -m : miscellaneous (app install with apt)
 -a : Application 
 --full : Install all from begin	

"
  ;;
esac

