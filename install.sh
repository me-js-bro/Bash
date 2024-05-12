#!/bin/bash

#########################################################
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

printf "${attention} - Installing bash files...\n \n \n" && sleep 0.5

# check if there is a .bash directory available. if available, then backup it.
if [ -d ~/.bash ]; then
    printf "${note} - A ${green}.bash${end} directory is available... Backing it up\n" && sleep 1

    cp -r ~/.bash ~/.bash-back
    printf "${done} - Backup done..\n \n"
fi

# now copy the .bash directory into the "$HOME" directory.
printf "${action} - Now installing the bash related files. \n \n"

cp -r .bash ~/
ln -sf ~/.bash/.bashrc ~/.bashrc

if [ -d ~/.bash ]; then
    printf "${done} - ${green}.bash${end} directory has been copied.\n" && sleep 1 && clear

    printf "${attention} - Now exit and re-open your terminal and enjoy...\n \n"
    # printf " \n"
fi
