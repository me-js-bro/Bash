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
common_packages=(
    bash-completion
    bat
    curl
    eza
    fastfetch
    figlet
    fzf
    git
    zoxide
)

for_opensuse=(
    python311
    python311-pip
    python311-pipx
)

clear

# package installation function
fn_install() {
    local pkg=$1

    if [ -n "$(command -v pacman)" ]; then  # Arch Linux
        sudo pacman -S --noconfirm "$pkg" 2>&1 | tee -a "$log"
    elif [ -n "$(command -v dnf)" ]; then  # Fedora
        sudo dnf install -y "$pkg" 2>&1 | tee -a "$log"
    elif [ -n "$(command -v zypper)" ]; then # opensuse
        sudo zypper in -y "$pkg" 2>&1 | tee -a "$log"
    elif [ -n "$(command -v apt)" ]; then	# debian
        sudo apt install -y "$pkg" 2>&1 | tee -a "$log"
    else
        echo "Unsupported distribution."
        return 1
    fi
}

# install the packages
for pkgs in "${common_packages[@]}"; do
   fn_install "$pkgs" 2>&1 | tee -a "$log"
done

if command -v zypper &> /dev/null; then
    for pkgs in "${for_opensuse[@]}"; do
        sudo zypper in -y "$pkgs" 2>&1 | tee -a "$log"
    done

    # installing thefu*k
    if command -v pipx &> /dev/null; then
        pipx runpip thefuck install setuptools &> /dev/null
        sleep 0.5
        pipx install --python python3.11 thefuck &> /dev/null 2>&1 | tee -a "$log"

        if command -v thefuck &> /dev/null; then
            printf "${done} - thef*ck was installed successfully!\n" && sleep 1
        fi
    fi

elif command -v pacman &> /dev/null; then  # Arch Linux
        sudo pacman -S --noconfirm thefuck 2>&1 | tee -a "$log"

elif command -v dnf &> /dev/null; then  # Fedora
        sudo dnf install -y thefuck 2>&1 | tee -a "$log"
fi

printf "${attention} - Installing bash files...\n \n \n" && sleep 0.5



# Check and backup the directories and file
for item in "$HOME/.bash" "$HOME/.bashrc"; do
    if [[ -d $item ]]; then
        mkdir -p ~/.Bash-Backup-${USER}
        case $item in
            $HOME/.bash)
                printf "${note} - A ${green}.bash${end} directory is available... Backing it up\n" 
                mv "$item" "$HOME/.Bash-Backup-${USER}/" 2>&1 | tee -a "$log"
                ;;
        esac
    elif [[ -f $item ]]; then
        case $item in
            $HOME/.bashrc)
                printf "${note} - A ${cyan}.bashrc${end} file is available... Backing it up\n" 
                mv "$item" "$HOME/.Bash-Backup-${USER}/" 2>&1 | tee -a "$log"
                ;;
        esac
    fi
done

# now copy the .bash directory into the "$HOME" directory.

printf "${attention} - Would you like to enable keybinds like vim? [ y/n ]\n"
read -p "Select: " vim

printf "${action} - Now installing the bash related files. \n \n"


cp -r .bash ~/ 2>&1 | tee -a "$log"

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
        mv ~/.blerc "$HOME/Bash-Backup-${USER}/"
    fi

    touch ~/.blerc
    echo "ble-face -s auto_complete fg=8,bg=none" >> ~/.blerc
    echo "ble-face -s syntax_default fg=1" >> ~/.blerc
fi

sleep 1

chmod +x ~/.bash/change_prompt.sh


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

eval "$(fzf --bash)" # fzf
eval "$(thefuck --alias)" #thefu*k
eval "$(thefuck --alias hell)" #thefu*k as hell
eval "$(zoxide init bash)" # zoxide
source ~/.bash/.bashrc 2>&1 | tee -a "$log"

sleep 1 && clear

# Function to print with typewriter effect
typewriter() {
    local text="$1"
    local delay="$2"
        printf "[ * ]\n"
    for (( i=0; i<${#text}; i++ )); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    printf "${end}\n"
}

# Call the function with the message and a delay of 0.05 seconds
completed="Bash configuration has been completed! Close the tarminal and open it again."
typewriter " $completed" 0.07
sleep 0.5
echo

completed="To change the shell prompt, type style and select from 1 to 6"
typewriter " $completed" 0.07
sleep 0.5
exit 0

#__________ ( code finishes here ) __________#
