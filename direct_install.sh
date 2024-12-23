#!/bin/bash

#---------------#
# ┏┳    ┳┓    
#  ┃┏   ┣┫┏┓┏┓
# ┗┛┛•  ┻┛┛ ┗┛     
#---------------#

# exit the script if there's any error
set -e

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

# initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${magenta} NOTE ${end}]"
done="[${cyan} DONE ${end}]"
ask="[${orange} QUESTION ${end}]"
error="[${red} ERROR ${end}]"

printf "${orange}[ * ] Starting the script.. Please have patience..${end} (•‿•)\n"

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
        printf "Unsupported distribution for now..Sorry.\n"
        exit 1
    fi
}


install_git && printf "${cyan}[ * ] Git was installed..${end}\n"

sleep 1

printf "\n${green}[ * ] Cloning the installation repository... Please have patience... ${end}\n"

[[ "$(pwd)" != "$HOME" ]] && cd "$HOME"

if [[ -d "Bash" ]]; then
    cd Bash
    if git pull origin main; then
        printf "\n${cyan}[ * ] Repository was updated successfully.${end} \n${green}[ * ] Now starting the main script... ${end}\n" && sleep 1 && clear
    else
        printf "\n${red}[ ! ] Failed to update the repository..${end}\n"
        exit 1
    fi
    
    chmod +x install.sh
    ./install.sh
else
    if git clone --depth=1 https://github.com/me-js-bro/Bash.git; then
        printf "\n${cyan}[ * ] Repository was cloned successfully!${end} \n${green}[ * ] Now starting the main script... ${end}\n" && sleep 1 && clear
    else
        printf "\n${red}[ ! ] Failed to clone the repository. Please check your internet connection or the repository URL.${end}\n"
        exit 1
    fi

    cd Bash
    chmod +x install.sh
    ./install.sh
fi

