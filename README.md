<h1 align='center'>My personl Bash Customization</h1>

<br>

## Here are some screenshos

<p> <img align="center" width="99%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/1.png?raw=true" /> </p>

<p> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/2.png?raw=true" /> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/3.png?raw=true" /></p>

<p> <img align="center" width="99%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/4.png?raw=true" /> </p>

<br>

## Styles

<p> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/Styles/style-1.png?raw=true" /> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/Styles/style-2.png?raw=true" /></p>

<p> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/Styles/style-4.png?raw=true" /> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/Styles/style-4-1.png?raw=true" /> </p>

<p> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/Styles/style-3.png?raw=true" /> <img align="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/bash/ScreenShots/Styles/style-5.png?raw=true" /></p>

<br>

## Some Info
<h4>I have tried do add some logos for different distros. Like you can see in the first screen shot. There is a logo of the OpenSuse. similarly I have added logos for: 
<br>
<br>
1) Arch <br>
2) ArcoLinux <br>
3) Manjaro <br>
4) Garuda <br>
5) Ubuntu <br>
6) Debian <br>
7) Linux Mint <br>
8) Zorin Os <br>
9) Pop Os! <br>
10) Kali Linux <br>
11) Parrot Os <br>
12) Fedora <br>
13) OpenSuse</h4> <br>

## Before Installation
#### Make sure you install any of the nerd font's and set that font in your terminal, so that the prompt look nice. I suggest to use the JetBrains Mono Nerd font. Just visit [Here](https://nerdfonts.com) and download the font and install it using your Font Manager. Then set the font in your terminal.
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
#### Simply go to `~/.bash` directory. Inside it, you will find `.bashrc`, `alias` and `function` file. Just edit these files and you are good to go.

## Command Shortcuts

### 1) Directory Navigation and File Management

| Shortcut | Command | Description |
|----------|---------|-------------|
| `cd`     | `cd`    | Change directory. If the directory does not exist, it will ask to create it. |
| `cD`     | `cd ~/Downloads` | Change to the Downloads directory. |
| `cP`     | `cd ~/Pictures`  | Change to the Pictures directory. |
| `cV`     | `cd ~/Videos`    | Change to the Videos directory. |
| `md`     | `mkdir`          | Make a directory. |
| `tc`     | `touch`          | Create a file. |
| `r`      | `rm -rf`         | Remove both files and directories. |

### 2) Updated Install/Uninstall Related

| Shortcut | Command | Description |
|----------|---------|-------------|
| `cu`     | `dnf check-update` or `zypper list-updates` | Checks system updates (Fedora, OpenSuse). |
| `cuo`    | `checkupdates` | Checks system updates (Arch Official). |
| `cua`    | `"$aur" -Qua` | Checks system updates (Arch Aur). |
| `up`     | `dnf upgrade`, `zypper update`, or `apt-get update` | Updates the system packages (Fedora, OpenSuse, Debian/Ubuntu). |
| `upo`    | `pacman -Syu`     | Updates the official repo (Arch). |
| `upa`    | `yay -Syu`        | Updates the AUR helper (Arch). |
| `in`     | `dnf install`, `zypper install`, or `apt-get install` | Install package (Fedora, OpenSuse, Debian/Ubuntu). |
| `un`     | `dnf remove`, `zypper remove`, or `apt-get remove` | Uninstall package (Fedora, OpenSuse, Debian/Ubuntu). |
| `uno`    | `pacman -R`       | Uninstall from main repo (Arch). |
| `una`    | `yay -R`          | Uninstall from the AUR helper (Arch). |

### 3) Git Related

| Shortcut | Command | Description |
|----------|---------|-------------|
| `gc`     | `git clone`         | Clone a repository. |
| `gcd`    | `git clone --depth=1` | Clone a repository with depth 1. |
| `gcm`    | `git commit -m`     | Commit with a message. |
| `gp`     | `git push`          | Push changes to the remote repository. |
| `gpu`    | `git push -u origin main` | Push changes and set upstream to main. |
| `gpo`    | `git push origin [branch]` | Push to a specified branch. |

### 4) Changing Style

| Shortcut | Command | Description |
|----------|---------|-------------|
| `style`  | `bash ~/.bash/change_prompt.sh` | Execute a script that changes the style of the bash |

### Feel free to add your own shortcuts into the `~/.bash/alias` file, and functions into the `~/.bash/functions` file