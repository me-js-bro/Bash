#!/bin/bash

# Function to display the menu
display_menu() {
    echo "Select a prompt style:"
    echo "1) Style 1 (2 lines)"
    echo "2) Style 2 (one line)"
    echo "3) Style 3 (2 lines)"
    echo "4) Style 4 (2 lines for git info) (Default)"
    echo "5) Style 5 (like zsh)"
    echo "q) Quit"
}

display_menu
read -n1 -rep "Choose Your style: " style

# case to choose the PS1 variable
case $style in
    1)
        PS1='┌( \u )─[$(if [[ "$PWD" = "$HOME" ]]; then echo " \e[1;36m \e[1;0m"; elif [[ "$PWD" = "/" ]]; then echo " \e[1;32m \e[1;0m"; else echo " \w"; fi) $(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")]\n└─ $(check_distro)|> '
        ;;
    2)
        PS1='$(if [[ "$PWD" = "$HOME" ]]; then echo " \e[1;36m \e[1;0m" $(check_distro); elif [[ "$PWD" = "/" ]]; then echo " \e[1;32m \e[1;0m"; else echo " \W"; fi) $(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")\e[1;32m\e[1;0m '
        ;;
    3)
        PS1='\n$(if [[ "$PWD" = "$HOME" ]]; then echo " \e[1;36m \e[1;0m" $(check_distro); elif [[ "$PWD" = "/" ]]; then echo " \e[1;32m \e[1;0m"; else echo " \w"; fi) $(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")\n \e[1;32m\e[1;0m '
        ;;
    4)
        PS1='$(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "") \n $(if [[ "$PWD" = "$HOME" ]]; then echo "\e[1;36m󰜥\e[1;0m"; elif [[ "$PWD" = "/" ]]; then echo "\e[1;36m\e[1;0m"; else echo "\W"; fi) \e[1;32m\e[1;0m ' 
        ;;
    5)
        PS1=' $(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")\n \e[1;36m╭─\e[1;0m $(if [[ "$PWD" = "$HOME" ]]; then echo "\e[1;36m  $(check_distro)\e"; elif [[ "$PWD" = "/" ]]; then echo "\e[1;36m\e[1;0m"; else echo "\e[1;33m\w"; fi) \n \e[1;36m╰──\e[1;32m❯\e[1;0m '
        ;;
    q)
        echo "Quitting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Please try again."
        exit 1
        ;;
esac

# Escape backslashes, forward slashes, and newlines in PS1 for sed
escaped_PS1=$(printf '%s\n' "$PS1" | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e ':a;N;$!ba;s/\n/\\n/g')

# bash file
bashrc=~/.bash/.bashrc

# Update the PS1 line in the specified file
sed -i "/^PS1=/c\\PS1='$escaped_PS1'" "$bashrc"

source ~/.bash/.bashrc

printf "Now relaunch your terminal and you're good to go...\n"

