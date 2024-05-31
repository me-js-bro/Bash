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

touch install-log
log=install-log

# required packages
package=(
    bash-completion
    bat
    curl
    git
    lsd
)


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
printf "${action} - Now installing the bash related files. \n \n"

cp -r .bash ~/ 2>&1 | tee -a "$log"
cp -r lsd ~/.config/ 2>&1 | tee -a "$log"
ln -sf ~/.bash/.bashrc ~/.bashrc 2>&1 | tee -a "$log"


# installing bash autosuggestions and syntal highlighting.
if [ -d ~/.bash ]; then
    printf "${action} - Updating some scripts...\n" && sleep 1

    curl -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf - 2>&1 | tee -a "$log"
    bash ble-nightly/ble.sh --install ~/.local/share 2>&1 | tee -a "$log"
    echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bash/.bashrc 2>&1 | tee -a "$log"

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

printf "${attention} - Re-open the terminal after you finish your work....\n" && sleep 1
