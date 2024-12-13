# ~/.bash/.bashrc

#---------------#
# ┏┳    ┳┓    
#  ┃┏   ┣┫┏┓┏┓
# ┗┛┛•  ┻┛┛ ┗┛     
#---------------#                                          

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# initialize features [ check ~/.bash/functions/fn_init ]
fn_init

export PROMPT_COMMAND='precmd; preexec'

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

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head 200; else bat -n --color=always --line-range :1000 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

unset rc

# source all the alias and functions
source ~/.bash/functions
source ~/.bash/alias
source ~/.local/share/blesh/ble.sh
