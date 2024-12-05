#!/bin/bash

#---------------#
# ┏┳    ┳┓    
#  ┃┏   ┣┫┏┓┏┓
# ┗┛┛•  ┻┛┛ ┗┛     
#---------------#

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
megenta="\e[1;1;35m"
cyan="\e[1;36m"
end="\e[1;0m"

# initial texts
attention="${yellow}[ ATTENTION ]${end}"
action="${green}[ ACTION ]${end}"
note="${megenta}[ NOTE ]${end}"
done="${cyan}[ DONE ]${end}"
error="${red}[ ERROR ]${end}"

# log file
dir=`pwd`
log="$dir/bash-install-$(date +%I:%M_%p).log"
touch "$log"

# required packages
package=(
    bash-completion
    bat
    curl
    fastfetch
    figlet
    git
    lsd
    xclip
)

 pkg_for_ubuntu=(
    bash-completion
    bat
    curl
    git
    neofetch
 )

# package installation function
fn_install() {

    if [ -n "$(command -v pacman)" ]; then  # Arch Linux
        sudo pacman -S --noconfirm "$1" 2>&1 | tee -a "$log"
    elif [ -n "$(command -v dnf)" ]; then  # Fedora
        sudo dnf install -y "$1" "$1" 2>&1 | tee -a "$log"
    elif [ -n "$(command -v zypper)" ]; then  # openSUSE
        sudo zypper in -y "$1" "$1" 2>&1 | tee -a "$log"
    elif [ -n "$(command -v apt)" ]; then	# debian
        if [ -f "/etc/os-release" ]; then
            source "/etc/os-release"

            if [[ "$ID" != "ubuntu" || "$ID" != "zorin" ]]; then
    	        sudo apt install "$1" "$1" 2>&1 | tee -a "$log"
            fi
        fi
    else
        echo "Unsupported distribution."
        return 1
    fi
}

# install the packages
for pkgs in "${package[@]}"; do
   fn_install "$pkgs" 2>&1 | tee -a "$log"
done

# installing packages if the distro is ubuntu or zprin os
if [ -n "$(command -v apt)" ]; then
    if [ -f "/etc/os-release" ]; then
        source "/etc/os-release"

        if [[ "$ID" == "ubuntu" || "$ID" == "zorin" ]]; then
            for pkgs in "${pkg_for_ubuntu[@]}"; do
                sudo apt install "$pkgs" -y 2>&1 | tee -a "$log"
            done

            # installing lsd from snap
            sudo snap install lsd
        fi
    fi
fi

printf "${attention} - Installing bash files...\n \n \n" && sleep 0.5


# Check and backup the directories and file
for item in "$HOME/.bash" "$HOME/.bashrc" "$HOME/.config/lsd"; do
    if [[ -d $item ]]; then
        case $item in
            $HOME/.bash)
                printf "${note} - A ${green}.bash${end} directory is available... Backing it up\n" 
                cp -r "$item" "$HOME/.bash-back" 2>&1 | tee -a "$log"
                ;;
            $HOME/.config/lsd)
                printf "${note} - A ${yellow}~/.config/lsd${end} directory is available... Backing it up\n" 
                cp -r "$item" "$HOME/.config/lsd-back" 2>&1 | tee -a "$log"
                ;;
        esac
    elif [[ -f $item ]]; then
        case $item in
            $HOME/.bashrc)
                printf "${note} - A ${cyan}.bashrc${end} file is available... Backing it up\n" 
                cp "$item" "$HOME/.bashrc-back-main" 2>&1 | tee -a "$log"
                ;;
        esac
    fi
done


# now copy the .bash directory into the "$HOME" directory.

printf "${attention} - Would you like to enable keybinds like vim? [ y/n ]\n"
read -p "Select: " vim

printf "${action} - Now installing the bash related files. \n \n"


cp -r .bash ~/ 2>&1 | tee -a "$log"
cp -r lsd ~/.config/ 2>&1 | tee -a "$log"

if [[ "$vim" =~ ^[Yy]$ ]]; then
    echo "set -o vi" >> ~/.bash/.bashrc
fi

ln -sf ~/.bash/.bashrc ~/.bashrc 2>&1 | tee -a "$log"

# installing bash autosuggestions and syntal highlighting.
if [ -d ~/.bash ]; then
    printf "${action} - Updating some scripts...\n" && sleep 1

    curl -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf - 2>&1 | tee -a "$log"
    bash ble-nightly/ble.sh --install ~/.local/share 2>&1 | tee -a "$log"

    if [ -f ~/.blerc ]; then
        printf "${action} - Backing up ~/.blerc file \n"

        cp ~/.blerc ~/.blerc-back
    fi

    touch ~/.blerc
    echo "ble-face -s auto_complete fg=8,bg=none" >> ~/.blerc
    echo "ble-face -s syntax_default fg=1" >> ~/.blerc
fi

sleep 1

chmod +x ~/.bash/change_prompt.sh

# source ~/.blerc 2>&1 | tee -a "$log"
source ~/.bash/.bashrc 2>&1 | tee -a "$log"

sleep 1 && clear

printf "${attention} - Would you like to install a Nerd font? In this case, the 'JetBrains Mono Nerd' font? It is important. [ y/n ] \n"
read -p "Select: " font

if [[ "$font" =~ ^[Yy]$ ]]; then
    printf "${green} [ * ] - Installing the ${cyan}JetBrains Mono Nerd font ${end} \n"

    DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
    # Maximum number of download attempts
    MAX_ATTEMPTS=2
    for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
        curl -OL "$DOWNLOAD_URL" && break
        printf "Download attempt $ATTEMPT failed. Retrying in 2 seconds...\n"
        sleep 2
    done

    # Check if the JetBrainsMono folder exists and delete it if it does
    if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
        rm -rf ~/.local/share/fonts/JetBrainsMonoNerd
    fi

    mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
    # Extract the new files into the JetBrainsMono folder and log the output
    tar -xJkf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd

    # Update font cache and log the output
    sudo fc-cache -fv &> /dev/null

    # clean up 
    if [ -d "JetBrainsMono.tar.xz" ]; then
        rm -r JetBrainsMono.tar.xz
    fi
else
    printf "${attention} - Please install a nerd font manually and set it to your terminal. \n"
fi


printf "${attention} - Re-open the terminal after you finish your work....\n" && sleep 1 && exit 0

#__________ ( code finishes here ) __________#