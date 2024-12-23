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


git_info() {
  # Check if current directory is a Git repository
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Get the current branch name
    branch_name=$(git branch --show-current 2>/dev/null)

    # Get the number of unpushed commits (using wc)
    unpushed_count=$(git status --porcelain=v1 | wc -l 2>/dev/null || printf 0)


    # Print information
    if [[ -n "$branch_name"  ]]; then
      printf "\e[1;34m\e[1;32m $branch_name\e[1;0m\u001b[35;1m \e[1;0m"  # add this if you want a blinking icon "\u001b[5m"

      if [[ "$unpushed_count" -gt 0 ]]; then
        printf "\e[1;38;5;214m!$unpushed_count \e[3;0m\n"  # Unpushed count in orange
      else
        printf "\e[1;32m✓ \e[3;0m\n"  # shows an icon
      fi
    fi
  fi
}

# # Function to capture the start time
preexec() {
    export command_start_time=$(date +%s)
}

# Function to capture the end time and calculate elapsed time
precmd() {
    if [[ -n $command_start_time && $command_start_time -ne 0 ]]; then
        local command_end_time=$(date +%s)
        local elapsed_time=$((command_end_time - command_start_time))

        # Convert elapsed time to minutes and seconds
        local minutes=$((elapsed_time / 60))
        local seconds=$((elapsed_time % 60))

        # Only display elapsed time if it is greater than zero
        if [[ $elapsed_time -gt 0 ]]; then
            if [[ $minutes -gt 0 ]]; then
                export elapsed_time_display=$(printf "\n%dm %ds" $minutes $seconds)
            else
                export elapsed_time_display=$(printf "\n%ds" $seconds)
            fi
        else
            export elapsed_time_display=""
        fi
    else
        export elapsed_time_display=""
    fi
    export command_start_time=0  # Reset start time to 0 after each command
}

# Function to capture the current time
current_time() {
    echo $(date +%I:%M\ %p)
}
