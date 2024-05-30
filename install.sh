#!/bin/bash

#################   Bash Installation   #################
#                                                       #
#       ███╗   ███╗ █████╗ ██╗  ██╗██╗███╗   ██╗        #
#       ████╗ ████║██╔══██╗██║  ██║██║████╗  ██║        #
#       ██╔████╔██║███████║███████║██║██╔██╗ ██║        #
#       ██║╚██╔╝██║██╔══██║██╔══██║██║██║╚██╗██║        #
#       ██║ ╚═╝ ██║██║  ██║██║  ██║██║██║ ╚████║        #
#       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝        #
#                                                       #
#########################################################

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

# required packages
package=(
    bash-completion
    curl
    git
)

clear

# package installation function
fn_install() {

    if [ -n "$(command -v pacman)" ]; then  # Arch Linux
        sudo pacman -S --noconfirm "$1"
    elif [ -n "$(command -v dnf)" ]; then  # Fedora
        sudo dnf install -y "$1"
    elif [ -n "$(command -v zypper)" ]; then  # openSUSE
        sudo zypper in "$1"
    elif [ -n "$(command -v apt)" ]; then	# ubuntu or ubuntu based
    	sudo apt install "$1"
    else
        echo "Unsupported distribution."
        return 1
    fi
}

for pkgs in "${package[@]}"; do
    fn_install "$pkgs"
done

printf "${attention} - Installing bash files...\n \n \n" && sleep 0.5

# check if there is a .bash directory available. if available, then backup it.
if [[ -d ~/.bash && -f ~/.bashrc]]; then
    printf "${note} - A ${green}.bash${end} directory is available... Backing it up\n" && sleep 1

    cp -r ~/.bash ~/.bash-back
    cp ~/.bashrc ~/.bashrc-back-mail
    printf "${done} - Backup done..\n \n"
fi

# now copy the .bash directory into the "$HOME" directory.
printf "${action} - Now installing the bash related files. \n \n"

cp -r .bash ~/
ln -sf ~/.bash/.bashrc ~/.bashrc


# installing bash autosuggestions and syntal highlighting.
if [ -d ~/.bash ]; then
    printf "${action} - Updating some scripts...\n" && sleep 1

    curl -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf -
    bash ble-nightly/ble.sh --install ~/.local/share
    echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bash/.bashrc

    if [ ! -f ~/.blerc ]; then
        touch ~/.blerc
        echo "ble-face -s auto_complete fg=8,bg=none" >> ~/.blerc
        echo "ble-face -s syntax_default fg=1" >> ~/.blerc
    fi
fi

sleep 1

chmod +x ~/.bash/change_prompt.sh

source ~/.blerc

printf "${attention} - Re-open the terminal after you finish your work....\n" && sleep 1 && clear
