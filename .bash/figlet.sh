#!/bin/bash
figlet -f smslant "Figlet"
echo 

read -p "Enter the text for ascii encoding: " mytext

if [ -f ~/.bash/figlet.txt ]; then
    touch ~/.bash/figlet.txt
fi

figlet -f smslant "$mytext" >> ~/.bash/figlet.txt
echo "" >> ~/.bash/figlet.txt

lines=$( cat ~/.bash/figlet.txt )
wl-copy "$lines"
xclip -sel clip ~/.bash/figlet.txt

echo ":: Text copied to clipboard!"
