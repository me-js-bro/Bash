# ~/.bash/.bashrc

#---------------#
# ┏┳    ┳┓    
#  ┃┏   ┣┫┏┓┏┓
# ┗┛┛•  ┻┛┛ ┗┛     
#---------------#                                          

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --attach=none

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Call update_ps1 before each prompt
export PROMPT_COMMAND='precmd; preexec'

# ================================= prompt ================================= #
PS1='$(if [[ "$PWD" = "$HOME" ]]; then echo "\e[1;36m\e[1;0m"; elif [[ "$PWD" = "/" ]]; then echo " \e[1;0m"; elif [[ ! "$PWD" == "$HOME" ]]; then echo "\n\w"; fi)\n\e[1;32m❯\e[1;0m '

# set prompt starship
# eval "$(starship init bash)"



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


# ================================= fzf ================================= #
if [[ -x "$(command -v fzf)" ]]; then
	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
	  --info=inline-right \
	  --ansi \
	  --layout=reverse \
	  --border=rounded \
	  --color=border:#27a1b9 \
	  --color=fg:#c0caf5 \
	  --color=gutter:#16161e \
	  --color=header:#ff9e64 \
	  --color=hl+:#2ac3de \
	  --color=hl:#2ac3de \
	  --color=info:#545c7e \
	  --color=marker:#ff007c \
	  --color=pointer:#ff007c \
	  --color=prompt:#2ac3de \
	  --color=query:#c0caf5:regular \
	  --color=scrollbar:#27a1b9 \
	  --color=separator:#ff9e64 \
	  --color=spinner:#ff007c \
	"
fi

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

# Configure FZF for directory preview
if command -v fzf &> /dev/null; then
  _fzf_preview() {
    eza --color=always --icons=always "$1"
  }

  # For zoxide integration with FZF (if zoxide is installed)
  if command -v zoxide &> /dev/null; then
    alias zi='zoxide query -i | xargs -r eza --color=always --icons=always'
  fi
fi


# ================================= completion and autocd ================================= #
bind "set completion-ignore-case on"
shopt -s autocd
unset rc


# ================================= fastfetch ================================= #
fastfetch


# ================================= add functionalities ================================= #
eval "$(fzf --bash)" # fzf
eval "$(thefuck --alias)" # thefu*k
eval "$(thefuck --alias hell)" # thefu*k
eval "$(zoxide init bash)" # zoxide


# ================================= source functions, aliases and blers ================================= #
source ~/.bash/functions.sh
source ~/.bash/alias.sh
source ~/.local/share/blesh/ble.sh
source ~/.bash/.blerc


# ================================= transient prompt and right prompt ================================= #
bleopt prompt_ps1_transient=always
bleopt prompt_ps1_final="❯ "

# bleopt prompt_rps1='\n$(current_time)'
bleopt prompt_rps1='\n$(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")${elapsed_time_display}'


# ================================= vi mode ================================= #
if [[ $- == *i* ]]; then
  bind 'set editing-mode vi'
fi
bleopt keymap_vi_mode_show:=
bind "set show-mode-in-prompt on"
bind "set vi-cmd-mode-string "
bind "set vi-ins-mode-string "


# ================================= ble-attach ================================= #
[[ ${BLE_VERSION-} ]] && ble-attach
