# ~/.bash/.bashrc


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load starship prompt if starship is installed
if [ -x /usr/bin/starship ]; then
	__main() {
		local major="${BASH_VERSINFO[0]}"
		local minor="${BASH_VERSINFO[1]}"

		if ((major > 4)) || { ((major == 4)) && ((minor >= 1)); }; then
			source <("/usr/bin/starship" init bash --print-full-init)
		else
			source /dev/stdin <<<"$("/usr/bin/starship" init bash --print-full-init)"
		fi
	}
	__main
	unset -f __main
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# source all the alias and functions
source ~/.bash/functions
source ~/.bash/alias

PROMPT_COMMAND='precmd; preexec'

# Set prompt
PS1='\e[90m${elapsed_time_display}\e[0m\n╭( \u )─[$(if [[ "$PWD" = "$HOME" ]]; then echo " \e[1;36m \e[1;0m"; elif [[ "$PWD" = "/" ]]; then echo " \e[1;32m \e[1;0m"; else echo "\e[1;33m \W\e[1;0m"; fi) ]$(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo ──{ $(git_info) }─ || echo "")─( $(current_time) )\n╰─\e[1;32m❯\e[1;0m '



# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

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
neofetch | lolcat
source ~/.local/share/blesh/ble.sh
source ~/.local/share/blesh/ble.sh

# figlet "fedora" | lolcat
# figlet -f slant "Fedora" | lolcat
# source ~/.bash/logo.sh | lolcat 
