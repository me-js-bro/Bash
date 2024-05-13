# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# source all the alias and functions
source ~/.bash/functions
source ~/.bash/alias

# color defination
# red="\e[1;31m"
# green="\e[1;32m"
# yellow="\e[1;33m"
# blue="\e[1;34m"
# megenta="\e[1;1;35m"
# cyan="\e[1;36m"
# end="\e[1;0m"


# PS1='┌─[\e[1;32m \w\e[1;0m ]\n└──|> '

PS1='┌─[\e[1;33m \w\e[1;0m $(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo '')]\n└─|> '

# PS1='┌─[\[\e[1;32m\]\w\[\e[0m\]]\n'  # Base prompt

# if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
#   PS1+='└─[ $(git_info) ]> '  # Call git_info function using command substitution
# else
#   PS1+='└──|> '  # Default prompt if not a Git repository
# fi





# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

unset rc
neofetch
