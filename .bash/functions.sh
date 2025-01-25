# ~/.bash/functions.sh

# copy and paste Function
fn_copy_paste() {
    local destination="${!#}"  # Last parameter as the destination
    local items=("${@:1:$(($#-1))}")  # All parameters except the last one (items to copy)

    for item in "${items[@]}"; do
        if [[ -f "$item" ]]; then
            printf ":: Copying a file\n"
            cp "$item" "$destination"
        elif [[ -d "$item" ]]; then
            printf ":: Copying a directory\n"
            cp -r "$item" "$destination"
        fi
    done
}

# remove files and directories
fn_removal() {
    for item in "$@"; do
        if [[ -f "$item" ]]; then
            printf ":: Removing a file\n"
            rm "$item"
        elif [[ -d "$item" ]]; then
            printf ":: Removing a directory\n"
            rm -rf "$item"
        else
            printf "[ !! ]\n$item does not exist or is neither a regular file nor a directory\n"
        fi
    done
}

# disk spaces
fn_resources(){
    case $1 in
        __disk)
            disk_total=$(df / -h | awk 'NR==2 {print $2}')
            disk_used=$(df / -h | awk 'NR==2 {print $3}')
            disk_free=$(df / -h | awk 'NR==2 {print $4}')
            printf "Total: $disk_total\nUsed: $disk_used\nFree: $disk_free\n"
            ;;
        __memory)
            mem_total=$(free -h | awk 'NR==2 {print $2}')
            mem_used=$(free -h | awk 'NR==2 {print $3}')
            mem_free=$(free -h | awk 'NR==2 {print $7}')
            printf "Total: $mem_total\nUsed: $mem_used\nFree: $mem_free\n"
            ;;
    esac
}

# check updates
fn_check_updates() {
    if [ -n "$(command -v pacman)" ]; then  # Arch Linux
        # Check for updates
        aurhlpr=$(command -v yay || command -v paru)
        aur=$(${aurhlpr} -Qua | wc -l)
        
        ofc=$(checkupdates | wc -l)

        # Calculate total available updates
        upd=$(( ofc + aur ))
        printf "[ UPDATES ]\n:: You have \e[1;32m$upd\e[0m updates available.\n:: Main: $ofc\n:: Aur: $aur\n"
    
    elif [ -n "$(command -v dnf)" ]; then  # Fedora
        upd=$(dnf check-update -q | wc -l)
        printf "[ UPDATES ]\n:: You have \e[1;32m$upd\e[0m updates available\n"

    elif [ -n "$(command -v zypper)" ]; then  # openSUSE
        upd=$(zypper lu --best-effort | grep -c 'v  |')
        printf "[ UPDATES ]\n:: You have \e[1;32m$upd\e[0m updates available\n"

    elif [ -n "$(command -v apt)" ]; then   # debian/ubuntu
        upd=$(apt list --upgradable 2> /dev/null | grep -c '\[upgradable from')
        printf "[ UPDATES ]\n:: You have \e[1;32m$upd\e[0m updates available\n"

    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the github repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# package updates
fn_update() {
    update_success=0
    network_error=0

    if [ -n "$(command -v pacman)" ]; then  # Arch Linux
        aur=$(command -v yay || command -v paru) # find the aur helper
        $aur -Syyu --noconfirm

    elif [ -n "$(command -v dnf)" ]; then  # Fedora
        sudo dnf update -y && sudo dnf upgrade -y --refresh
    elif [ -n "$(command -v zypper)" ]; then  # openSUSE
        sudo zypper ref && sudo zypper up -y
    elif [ -n "$(command -v apt)" ]; then  # Debian/Ubuntu
        sudo apt update -y && sudo apt upgrade -y
    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the github repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# Install software
fn_install() {

    if [ -n "$(command -v pacman)" ]; then  # Arch Linux

        pkg_manager=$(command -v pacman || command -v yay || command -v paru)
        aur=$(command -v yay || command -v paru) # find the aur helper

        $aur -S --noconfirm "$@"

    elif [ -n "$(command -v dnf)" ]; then  # Fedora

        sudo dnf install -y "$@"

    elif [ -n "$(command -v zypper)" ]; then  # openSUSE

        sudo zypper in -y "$@"

    elif [ -n "$(command -v apt)" ]; then  # Ubuntu or Ubuntu-based

        sudo apt install -y "$@"

    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the GitHub repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# package install
fn_uninstall() {
    if [ -n "$(command -v pacman)" ]; then  # Arch Linux
    
        pkg_manager=$(command -v pacman || command -v yay || command -v paru)
        aur=$(command -v yay || command -v paru)
        "$aur" -Rns "$@"

    elif [ -n "$(command -v dnf)" ]; then  # Fedora

        sudo dnf remove "$@"

    elif [ -n "$(command -v zypper)" ]; then  # openSUSE

        sudo zypper rm "$@"

    elif [ -n "$(command -v apt)" ]; then  # ubunt or related

        sudo apt remove "$@"

    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the github repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# compile cpp file with gcc
fn_compile_cpp() {
    filename="$1"
    if [ -n "$(command -v g++)" ]; then
        printf "\e[0;36m[ * ] - Compiling...!\e[0m\n\n"

        if g++ -std=c++20 "$filename".cpp -o "$filename"; then
            printf "\e[1;92m[ ✓ ] - Successfully compiled your code...!\e[0m\n"
            if [[ "$2" == "-o" ]]; then
                printf "\e[1;92m        Output: \e[0m\n\n" 
                ./$filename
            fi
        else
            printf "\n\e[1;91m[  ] - Error: Could not compile your code...!\e[0m\n"
        fi
    fi
}

# git info
git_info() {
  # Check if current directory is a Git repository
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    # Get the current branch name
    branch_name=$(git branch --show-current 2>/dev/null)

    # Count untracked files
    untracked_count=$(git status --porcelain | grep '^??' | wc -l)

    # Count unstaged changes (modified but not staged)
    unstaged_count=$(git diff --name-only | wc -l)

    # Count staged changes (staged but not committed)
    staged_count=$(git diff --cached --name-only | wc -l)

    # Print information
    if [[ -n "$branch_name" ]]; then
      printf "on \e[1;34m\e[1;32m $branch_name\e[1;0m\u001b[35;1m \e[1;0m"  # Git branch with icon

      if [[ "$untracked_count" -gt 0 ]]; then
        printf "\e[1;31m!$untracked_count \e[3;0m\n"  # Show untracked files in orange
      fi

      if [[ "$staged_count" -gt 0 ]]; then
        printf "\e[1;32m$staged_count \e[3;0m\n"  # Show staged files in green
      fi
      
      if [[ "$unstaged_count" -gt 0 ]]; then
        printf "\e[1;33m?$unstaged_count \e[3;0m\n"  # Show unstaged files in yellow

      fi

      if [[ "$untracked_count" -eq 0 && "$staged_count" -eq 0 && "$unstaged_count" -eq 0 ]]; then
        printf "\e[1;32m✓ Clean \e[3;0m\n"  # Show clean repository status
      fi
    fi
  fi
}

# fn for easy git push
gpush() {

    # Push function
    __push() {
        local current="$1"
        local commit="$2"
        if [[ "$current" == "main" ]]; then
            git add . && \
            git commit -m "$commit" && \
            git push
        else
            git add . && \
            git commit -m "$commit" && \
            git push origin "$current"
        fi
    }

    # Check if current directory is a Git repository
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Get the current branch name
        branch_name=$(git branch --show-current 2>/dev/null)

        # Count untracked files
        untracked_count=$(git status --porcelain | grep '^??' | wc -l)

        # Count unstaged changes (modified but not staged)
        unstaged_count=$(git diff --name-only | wc -l)

        # Count staged changes (staged but not committed)
        staged_count=$(git diff --cached --name-only | wc -l)

        # Display information
        if [[ -n "$branch_name" ]]; then
            if [[ "$untracked_count" -gt 0 ]]; then
                printf "=> %s untracked files\n" "$untracked_count"
            fi

            if [[ "$unstaged_count" -gt 0 ]]; then
                printf "=> %s uncommitted changes\n" "$unstaged_count"
            fi

            if [[ "$staged_count" -gt 0 ]]; then
                printf "=> %s staged changes\n" "$staged_count"
            fi

            if [[ "$untracked_count" -eq 0 && "$unstaged_count" -eq 0 && "$staged_count" -eq 0 ]]; then
                printf "✓ Nothing to push.\n"
            else
                printf "=> %s branch\n" "$branch_name"
                printf "\nWrite the commit message:\n"
                read -p "=> " msg
                sleep 0.5 && echo

                if command -v gum &> /dev/null; then
                    gum spin --spinner dot --title "Pushing to branch: $branch_name..." -- \
                        sleep 2
                        __push "$branch_name" "$msg"
                else
                    printf "Pushing to %s...\n" "$branch_name"
                    __push "$branch_name" "$msg"
                fi

                # Check the result of the last command
                if [[ "$untracked_count" -eq 0 && "$unstaged_count" -eq 0 && "$staged_count" -eq 0 ]]; then
                    printf ":: Pushed successfully!\n"
                else
                    printf "!! Sorry, push failed. Please check for errors.\n"
                fi
            fi
        fi
    else
        printf "!! Not inside a Git repository.\n"
    fi
}

# fn for yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Function to capture the start time
preexec() {
    export command_start_time=$(date +%s)
}

# Function to capture the end time and calculate elapsed time
precmd() {
    # Check if we are in transient prompt mode
    if [[ $prompt_ps1_transient != "always" ]]; then
        if [[ -n $command_start_time && $command_start_time -ne 0 ]]; then
            local command_end_time=$(date +%s)
            local elapsed_time=$((command_end_time - command_start_time))

            # Convert elapsed time to minutes and seconds
            local minutes=$((elapsed_time / 60))
            local seconds=$((elapsed_time % 60))

            # Only display elapsed time if it is greater than zero
            if [[ $elapsed_time -gt 0 ]]; then
                if [[ $minutes -gt 0 ]]; then
                    export elapsed_time_display=$(printf "\e[90m  %dm %ds\e[0m" $minutes $seconds)
                elif [[ $seconds -gt 3 ]]; then
                    export elapsed_time_display=$(printf "\e[90m  %ds\e[0m" $seconds)
                elif [[ $seconds -le 3 ]]; then
                    export elapsed_time_display=$(printf " \n")
                fi
            else
                export elapsed_time_display=""
            fi
        else
            export elapsed_time_display=""
        fi
    else
        # Clear the elapsed time display in transient mode
        export elapsed_time_display=""
    fi

    export command_start_time=0  # Reset start time to 0 after each command
}

# Function to capture the current time
current_time() {
    echo -e "\e[90m $(date +%I:%M\ %p)\e[0m"
}

random_bars() {
	columns=$(tput cols)
	chars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
	for ((i = 1; i <= $columns; i++))
	do
		echo -n "${chars[RANDOM%${#chars} + 1]}"
	done
	echo
}
