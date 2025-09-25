#!/bin/sh

echo 'installscript by borysus'

echo 'WARNING! This install script is made for systemd (including systemd-boot).'
echo "if you get a prompt asking you to type your password - type it, or to confirm something - type "y" or just click enter"
cd ~

PS3='Choose what you want to do: '
possibility=("Add Chaotic-AUR Repository" "Install my program pack" "Install Spicetify for Flatpak Spotify" "Change deafult shell to fish" "Set deafult power button behaviour to shutdown" "Install a DE" "Set GDM" "All" "Quit")
select opt in "${possibility[@]}"
do
    case $opt in
        "Add Chaotic-AUR Repository")
            func-chaotic-aur()
            break
            ;;
        "Install my program pack")
            func-install-programs()
            break
            ;;
        "Install Spicetify for Flatpak Spotify")
            func-install-spicetify()
            break
            ;;
        "Change deafult shell to fish")
            func-change-shell-to-fish()
            break
            ;;
        "Set deafult power button behaviour to shutdown")
            func-set-power-button-behaviour()
            break
            ;;
        "Install a DE")
            func-install-de()
            break
            ;;
        "Set GDM")
            func-set-gdm()
            break
            ;;
        "All")
            func-chaotic-aur()
            func-install-programs()
            func-install-spicetify()
            func-change-shell-to-fish()
            func-set-power-button-behaviour()
            func-install-de()
            func-set-gdm()
            break
            ;;
        "Quit")
        break
        ;;
        *) echo "Invalid option $REPLY";;
    esac
done
clear

func-chaotic-aur(){
echo 'Adding the Chaotic AUR repository...'
sleep 1
sudo pacman -Syu --noconfirm
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
sudo pacman -Syu --noconfirm
clear
}

func-install-programs(){
echo 'Installing the needed programs...'
sleep 1
sudo pacman -S --noconfirm --needed nano paru fastfetch fish bspwm gdm flatpak yay proton-vpn-gtk-app steam prismlauncher firefox ttf-ubuntu-font-family ttf-ubuntu-mono-nerd ttf-ubuntu-nerd zen-browser-bin code
flatpak install -y flathub com.spotify.Client org.vinegarhq.Sober
clear
}

func-install-spicetify(){
echo 'Installing spicetify...'
sleep 1
yay -S --noconfirm --needed spicetify-cli
flatpak install -y com.spotify.Client
spicetify
spicetify config prefs_path ~/.var/app/com.spotify.Client/config/spotify/prefs
spicetify config spotify_path /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/
sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify
sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps
spicetify backup apply
clear
}

func-change-shell-to-fish(){
echo 'Chainging the deafult shell to fish...'
sleep 1
sudo chsh -s /usr/bin/fish
chsh -s /usr/bin/fish
echo -e "function fish_greeting\n    fastfetch\n    echo The time is (set_color yellow)(date +%T)(set_color normal)\nend" >> ~/.config/fish/config.fish
clear
}

func-set-power-button-behaviour(){
echo 'Setting deafult power button behaviour...'
sleep 1
echo 'HandlePowerKey=poweroff' | sudo tee -a /etc/systemd/logind.conf
clear
}

func-install-de(){
echo 'Warning! When you choose bspwm or hyprland you need to make choices about the configuration of your desktop enviroment. A restart will be required! (My pick: bspwm)'
PS3='Choose the graphical enviroment: '
options=("bspwm" "hyprland" "Gnome" "KDE Plasma" "Cosmic" "None")
select opt in "${options[@]}"
do
    case $opt in
        "bspwm")
            echo "You chose bspwm"
            cd ~
            curl -LO http://gh0stzk.github.io/dotfiles/RiceInstaller
            chmod +x RiceInstaller
            ./RiceInstaller
            yay -S plasma-pa
            break
            ;;
        "hyprland")
            echo "You chose hyprland"
            yay -S --noconfirm --needed ml4w-hyprland plasma-pa
            ml4w-hyprland-setup
            break
            ;;
        "Gnome")
            echo "You chose Gnome"
            yay -S gnome plasma-pa
            break
            ;;
        "KDE Plasma")
            echo "You chose KDE Plasma"
            yay -S plasma
            break
            ;;
        "Cosmic")
            echo 'You chose Cosmic DE'
            yay -S cosmic
            break
            ;;
        "None")
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done
clear
}

func-set-gdm(){
echo 'Setting gdm as the deafult desktop manager...'
sleep 1
yay -S --needed gdm
sudo systemctl disable sddm
sudo systemctl stop sddm
sudo systemctl enable gdm
clear
}

echo 'Done! Thanks for using my script!'
sleep 2

