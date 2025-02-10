#!/bin/bash

#==============================================================================

# ███████╗██╗  ██╗███████╗██╗         ███╗   ██╗██╗███╗   ██╗     ██╗ █████╗ 
# ██╔════╝██║  ██║██╔════╝██║         ████╗  ██║██║████╗  ██║     ██║██╔══██╗
# ███████╗███████║█████╗  ██║         ██╔██╗ ██║██║██╔██╗ ██║     ██║███████║
# ╚════██║██╔══██║██╔══╝  ██║         ██║╚██╗██║██║██║╚██╗██║██   ██║██╔══██║
# ███████║██║  ██║███████╗███████╗    ██║ ╚████║██║██║ ╚████║╚█████╔╝██║  ██║
# ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝
                                                                            
#==============================================================================

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

printf "${orange}**${end} Starting the script...\n" && sleep 1

install_git() {

    if [ -n "$(command -v pacman)" ]; then  # Arch Linux

        if ! pacman -Qe git &> /dev/null; then
            sudo pacman -S --noconfirm git
        fi

    elif [ -n "$(command -v dnf)" ]; then  # Fedora

        if ! dnf list installed git &> /dev/null; then
            sudo dnf install git -y
        fi

    elif [ -n "$(command -v zypper)" ]; then  # openSUSE

        if ! zypper se -i git &> /dev/null; then
            sudo zypper in -y --no-recommends git
        fi

    elif [ -n "$(command -v apt)" ]; then  # Ubuntu/Debian

        if ! dpkg -l | grep -q "^ii  git "; then
            sudo apt install git -y
        fi

    else
        printf "${red}><${end} Unsupported distribution for now..Sorry.\n"
        exit 1
    fi
}

install_git && printf "${cyan}::${end} Git was installed..\n"

sleep 1

printf "\n${green}**${end} Cloning the installation repository...\n"

[[ "$(pwd)" != "$HOME" ]] && cd "$HOME"

if [[ -d "Bash" ]]; then
    cd Bash
    if git pull origin main; then
        printf "\n${cyan}::${end} Repository was updated successfull..\n${green}**${end} Now starting the main script...\n" && sleep 1 && clear
    else
        printf "\n${red}><${end} Failed to update the repository..."
        exit 1
    fi
    
    chmod +x install.sh
    ./install.sh
else
    printf "\n${green}**${end} Cloning the scripts...\n" && sleep 1 && clear
    git clone --depth=1 https://github.com/me-js-bro/Bash.git "$HOME/Bash" &> /dev/null

    if [[ -d "$HOME/Bash" ]]; then
        cd Bash
        chmod +x install.sh
        ./install.sh
    else
        printf "${red}><${end} Failed to clone repository...\n"
        exit 1
    fi
fi

