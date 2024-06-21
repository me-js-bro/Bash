#!/bin/bash

#______ If you want to add your prompt here, just add into the "case" condition, and also into the "display_menu function." ______#

# Function to display the menu
display_menu() {
    echo "Select a prompt style:"
    echo "1) Style 1"
    echo "2) Style 2"
    echo "3) Style 3"
    echo "4) Style 4"
    echo "5) Style 5"
    echo "6) Style 6"
    echo "7) Style 7"
    echo "8) Style 8"
    echo "q) Quit"
}

display_menu
read -n1 -rep "Choose Your style: " style

# case to choose the PS1 variable
# everything you see "\e[..." are just colors...
case $style in
    1)
        PS1='\e[90m${elapsed_time_display}\e[0m\n┌( \u )─[$(if [[ "$PWD" = "$HOME" ]]; then echo " \e[1;36m󰋜\e[1;0m"; elif [[ "$PWD" = "/" ]]; then echo " \e[1;32m$(check_distro)\e[1;0m"; else echo " \w"; fi) $(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")]\n└─|> '
        ;;
    2)
        PS1='\e[90m${elapsed_time_display}\e[0m\n$(if [[ "$PWD" = "$HOME" ]]; then echo "\e[1;36m\e[1;0m"; elif [[ "$PWD" = "/" ]]; then echo " \e[1;32m$(check_distro)\e[1;0m"; else echo "\W"; fi) $(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")\e[1;32m❯\e[1;0m '
        ;;
    3)
        PS1='\e[90m${elapsed_time_display}\e[0m\n$(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "") \n $(if [[ "$PWD" = "$HOME" ]]; then echo "\e[1;36m󰜥\e[1;0m"; elif [[ "$PWD" = "/" ]]; then echo "\e[1;36m\e[1;0m"; else echo "\W"; fi) \e[1;32m\e[1;0m ' 
        ;;
    4)
        PS1='\e[90m${elapsed_time_display}\e[0m\n\e[1;36m╭─\e[1;0m $(if [[ "$PWD" = "$HOME" ]]; then echo "\e[1;36m  $(check_distro)\e"; elif [[ "$PWD" = "/" ]]; then echo "\e[1;36m\e[1;0m"; else echo "\e[1;33m\w"; fi) $(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "") \n\e[1;36m╰──\e[1;32m❯\e[1;0m '
        ;;
    5)
        PS1='\e[90m${elapsed_time_display}\e[0m\n\e[1;36m╭─ \e[1;37m\u\e[1;34m@\e[1;37m\h\e[1;0m in $(if [[ "$PWD" = "$HOME" ]]; then echo "\e[1;36m󰜥"; elif [[ "$PWD" = "/" ]]; then echo "\e[1;36m\e[1;0m"; else echo "\e[1;33m\W"; fi) $(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")\n\e[1;36m╰──\e[1;32m󰘧\e[1;0m '
        ;;
    6)
        PS1='\e[90m${elapsed_time_display}\e[0m\n$(if [[ "$PWD" = "$HOME" ]]; then echo " " ; elif [[ "$PWD" = "/" ]]; then echo " \e[1;32mroot\e[1;0m"; else echo " \w"; fi) $(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")$(current_time)\n \e[1;32m❯\e[1;0m '
        ;;
    7)
        PS1='\e[90m${elapsed_time_display}\e[0m\n\e[1;36m \u\e[1;34m in \e[1;33m \h\e[1;0m // $(if [[ "$PWD" = "$HOME" ]]; then echo "\e[1;36m󰜥"; elif [[ "$PWD" = "/" ]]; then echo "\e[1;36m\e[1;0m"; else echo "\e[1;33m\w"; fi)$(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")\e[1;36m\e[1;32m\e[1;0m :$ '
        ;;
    8)
        PS1='\e[90m${elapsed_time_display}\e[0m\n╭( \u )─[$(if [[ "$PWD" = "$HOME" ]]; then echo " \e[1;36m \e[1;0m"; elif [[ "$PWD" = "/" ]]; then echo " \e[1;32m \e[1;0m"; else echo "\e[1;33m \W\e[1;0m"; fi) ]$(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo ──{ $(git_info) }─ || echo "")─( $(current_time) )\n╰─\e[1;32m❯\e[1;0m '
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