<h1 align='center'>My personl Bash Customization</h1>


## Short Description
#### Those who don't want to install and configure any other shell like the `zsh` or the `fish` shell, want to stay in the default `bash`, also want to make the experience of the bash more easy, can easily install this configuration. Just simply run the `install.sh` script. It will install some necessary packages and a github repo. And then you can enjoy the configuration.

<br>

## Here are some screenshos

<p> <img align="center" width="99%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/1.png?raw=true" /> </p>

<p> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/2.png?raw=true" /> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/3.png?raw=true" /></p>

<br>

## Styles

<p> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/Styles/style-1.png?raw=true" /> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/Styles/style-4.png?raw=true" /></p>

<p> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/Styles/style-4-1.png?raw=true" /> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/Styles/style-5.png?raw=true" /> </p>

<br>

## Some Info
<h4>I have tried do add some logos for different distros. Like you can see in the first screen shot. There is a logo of the OpenSuse. similarly I have added logos for: 
<br>
<br>
1) Arch <br>
2) ArcoLinux <br>
3) Manjaro <br>
4) Ubuntu <br>
5) Debian <br>
6) Linux Mint <br>
7) Zorin Os <br>
8) Pop Os! <br>
9) Kali Linux <br>
10) Parrot Os <br>
11) Fedora <br>
12) OpenSuse</h4> <br>

## Before Installation
#### Make sure you install any of the nerd font's and set that font in your terminal, so that the prompt look nice. I suggest to use the `JetBrains Mono Nerd Font`. Just visit [Here](https://nerdfonts.com) and download the font and install it using your Font Manager. Then set the font in your Terminal.
<br>

## Features
<h3> 
1) Shortcuts <br>
2) Some functions for install, uninstall, check updates, update packages and so on <br>
3) Syntax Highlighting <br>
4) Auto Suggestions <br>
5) Git branch name and left commits <br>
6) Some cool looking themes <br>
</h3>

<br>

## Installation
### Clone this repository to install my bash configs.
```
git clone --depth=1 https://github.com/me-js-bro/Bash.git
```

### Run these commands to install the files.

```
cd Bash
chmod +x install.sh
./install.sh
```

## Edit alias & functions
#### Simply go to `~/.bash` directory. Inside it, you will find `.bashrc`, `alias` and `function` file. Just edit these files and you are good to go. Also if you want to add your custom bash prompt, just go to `~/.bash/change_prompt.sh` file and add your prompt.

<br>

## Command Shortcuts

### 1) Directory Navigation and File Management

| Shortcut | Command | Description |
|----------|---------|-------------|
| `cd`     | `cd`    | Change directory. If the directory does not exist, it will ask to create it. |
| `cD`     | `cd ~/Downloads` | Change to the Downloads directory. |
| `cP`     | `cd ~/Pictures`  | Change to the Pictures directory. |
| `cV`     | `cd ~/Videos`    | Change to the Videos directory. |
| `dir`     | `mkdir`          | Make a directory. |
| `file`     | `touch`          | Create a file. |
| `rm`      | `rm -rf`         | Remove both files and directories. |
| `srm`      | `sudo rm -rf`         | Remove both files and directories with the sudo command |
| `ebash`   | `code .bash`    | Open .bash directory with the vs code to edit  |

### 2) Updated, Install & Uninstall Related

| Shortcut | Command | Description |
|----------|---------|-------------|
| `cu`     | `sudo dnf check-update` or `sudo zypper list-updates`  | Checks system updates (Fedora, OpenSuse. Also prints both Official and Aur updates in Arch Linux). |
| `update`     | `sudo dnf upgrade`, `sudo zypper update`, or `sudo apt-get update` | Updates the system packages (Fedora, OpenSuse, Debian/Ubuntu). |
| `updateO`    | `sudo pacman -Syu`     | Updates the official repo (Arch). |
| `updateA`    | `yay/paru -Syu`        | Updates the AUR helper (Arch). |
| `install`     | `sudo dnf install`, `zypper install`, or `apt-get install` | Install package (Fedora, OpenSuse, Debian/Ubuntu). |
| `installO`    | `sudo pacman -S`    | Install from official Packan repo |
| `installA`    | `yay/paru -S`     | Install from Arch User Repository (aur) |
| `remove`     | `sduo dnf remove`, `sudo zypper remove`, or `sudo apt-get remove` | Uninstall package (Fedora, OpenSuse, Debian/Ubuntu). |
| `removeO`    | `sudo pacman -R`       | Uninstall from main repo (Arch). |
| `removeA`    | `yay -R`          | Uninstall from the AUR helper (Arch). |

### 3) Git Related

| Shortcut | Command | Description |
|----------|---------|-------------|
| `add`     | `git add .`         | Add. |
| `clone`     | `git clone`         | Clone a repository. |
| `cloned`    | `git clone --depth=1` | Clone a repository with depth 1. |
| `commit`    | `git commit -m`     | Commit with a message. |
| `push`     | `git push`          | Push changes to the remote repository. |
| `pushm`    | `git push -u origin main` | Push changes and set upstream to main. |
| `pusho`    | `git push origin [branch]` | Push to a specified branch. |

### 4) Changing Style

| Shortcut | Command | Description |
|----------|---------|-------------|
| `style`  | `bash ~/.bash/change_prompt.sh` | Execute a script that changes the style of the bash |
