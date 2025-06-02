# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.

# Color configuration for prompt according to user (root/non-root)
if [ $(id -u) -eq 0 ]; then
  # Root user - prompt in red
  PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  # Normal user - prompt in green
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Configuration for dircolors (colors in ls)
export LS_OPTIONS='--color=auto'
eval "$(dircolors -b)"

# Common aliases
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias la='ls $LS_OPTIONS -A'
alias l='ls $LS_OPTIONS -lA'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Some aliases to avoid mistakes
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# Add bin directories to PATH if they exist
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# Load custom aliases if the file exists
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Set default editor
# export EDITOR=nano
export EDITOR=vim

# Improve the cd command
# 'cd -' to go back to the previous directory
# 'cd' alone to go to the home directory
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Function to create a directory and enter it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# History: do not save duplicate commands and commands starting with space
HISTCONTROL=ignoreboth

# History size
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command
shopt -s checkwinsize

# Improve terminal experience
shopt -s autocd   # Change to a directory by just typing its name
shopt -s cdspell  # Autocorrect minor typos in cd
shopt -s dirspell # Autocorrect typos in directory names during autocompletion
shopt -s globstar # Enable ** pattern to match all files and directories recursively

# Enable autocompletion if available
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Additional useful aliases
alias free='free -h'
alias df='df -h'
alias du='du -h'
alias ports='netstat -tulanp'                                                  # Shows open ports
alias myip='curl -s https://ipinfo.io/ip || curl -s https://ifconfig.me; echo' # Shows public IP
alias myiplocal='hostname -I | awk "{print \$1}"'                              # Shows local IP
alias clearhistory='history -c && history -w'                                  # Clear history
alias path='echo -e ${PATH//:/\\n}'                                            # Shows PATH in separate lines
alias weather='curl wttr.in'                                                   # Shows current weather (requires internet connection)

# History with date and time
export HISTTIMEFORMAT="%d/%m/%y %T "

# Function to search in history
function hg() {
  history | grep "$1"
}

# Function to easily extract compressed files
extract() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar e $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# System information at terminal startup
system_info() {
  # Colors
  local RED="\033[1;31m"
  local GREEN="\033[1;32m"
  local YELLOW="\033[1;33m"
  local BLUE="\033[1;34m"
  local PURPLE="\033[1;35m"
  local CYAN="\033[1;36m"
  local WHITE="\033[1;37m"
  local ORANGE="\033[1;33m"
  local GRAYBOLD="\033[1;37m"
  local GRAY="\033[0;37m"
  local RESET="\033[0m"

  # Separator for better visualization
  echo -e "${GRAY}╭─────────────────────────── SYSTEM INFORMATION ───────────────────────────╮${RESET}"

  # Current date and time
  printf "${WHITE}%-12s :${RESET} %s\n" "Date/Time" "$(date '+%Y-%m-%d %H:%M:%S')"

  # User and hostname
  printf "${PURPLE}%-12s :${RESET} %s\n" "User" "$(whoami)@$(cat /etc/hostname)"

  # IP addresses
  printf "${WHITE}%-12s :${RESET} %s\n" "Local IP" "$(hostname -I | awk '{print $1}')"

  # System and kernel
  printf "${BLUE}%-12s :${RESET} %s %s\n" "System" "$(uname -o)" "$(uname -m)"

  # Distribution (if the file exists)
  if [ -f /etc/os-release ]; then
    DISTRO=$(grep -w "PRETTY_NAME" /etc/os-release | cut -d= -f2 | tr -d '"')
    printf "${BLUE}%-12s :${RESET} %s\n" "Distribution" "$DISTRO"
  fi

  printf "${RED}%-12s :${RESET} %s\n" "Kernel" "$(uname -r)"
  printf "${GREEN}%-12s :${RESET} %s\n" "Uptime" "$(uptime -p | sed 's/up //')"

  # CPU information
  CPU_MODEL=$(grep -m 1 "model name" /proc/cpuinfo | cut -d: -f2 | sed 's/^ //g')
  CPU_CORES=$(grep -c "processor" /proc/cpuinfo)
  printf "${CYAN}%-12s :${RESET} %s\n" "CPU" "$CPU_MODEL"
  printf "${CYAN}%-12s :${RESET} %s\n" "CPU Cores" "$CPU_CORES"

  # CPU temperature (if sensors is installed)
  if command -v sensors &> /dev/null; then
    CPU_TEMP=$(sensors | grep -m 1 "Core 0" | awk '{print $3}')
    if [ ! -z "$CPU_TEMP" ]; then
      printf "${RED}%-12s :${RESET} %s\n" "CPU Temp" "$CPU_TEMP"
    fi
  fi

  # Memory and disk usage
  printf "${YELLOW}%-12s :${RESET} %s\n" "Memory" "$(free -h | awk '/^Mem:/ {print $3 " of " $2 " used (" int($3/$2*100) "%)"}')"
  printf "${YELLOW}%-12s :${RESET} %s\n" "Swap" "$(free -h | awk '/^Swap:/ {if ($2 == "0B") print "Not available"; else print $3 " of " $2 " used (" int($3/$2*100) "%)"}' 2>/dev/null || echo "Not available")"
  printf "${PURPLE}%-12s :${RESET} %s\n" "Disk (/) " "$(df -h --output=used,size,pcent / | awk 'NR==2 {print $1 " of " $2 " used (" $3 ")"}')"

  # Home folder (if on a separate partition)
  if df -h | grep -q "/home"; then
    printf "${PURPLE}%-12s :${RESET} %s\n" "Disk (/home)" "$(df -h --output=used,size,pcent /home | awk 'NR==2 {print $1 " of " $2 " used (" $3 ")"}')"
  fi

  # Processes
  PROCESS_COUNT=$(ps aux | wc -l)
  printf "${ORANGE}%-12s :${RESET} %s\n" "Processes" "$((PROCESS_COUNT-1))"  # Subtract 1 for the header

  # System load
  printf "${CYAN}%-12s :${RESET} %s\n" "Load" "$(cat /proc/loadavg | cut -d' ' -f1-3)"

  # Connected users
  USERS_ON=$(who | wc -l)
  printf "${GREEN}%-12s :${RESET} %s\n" "Users" "$USERS_ON connected"

  # Services (systemd)
  if command -v systemctl &> /dev/null; then
    SERVICES_RUNNING=$(systemctl list-units --type=service --state=running | grep -c "\.service")
    SERVICES_FAILED=$(systemctl list-units --type=service --state=failed | grep -c "\.service")
    printf "${RED}%-12s :${RESET} %s running, %s failed\n" "Services" "$SERVICES_RUNNING" "$SERVICES_FAILED"
  fi

  # Network information
  CONNECTIONS=$(netstat -ant | grep ESTABLISHED | wc -l)
  printf "${BLUE}%-12s :${RESET} %s established\n" "Connections" "$CONNECTIONS"

  # Last logins
  printf "${GRAYBOLD}%-12s :${RESET}\n" "Last logins"
  printf "${GRAY}%-12s %-20s %-15s %-15s\n" " User" "         Date and Time" "     Origin" "        IP"
  printf "${GRAY}%-12s\n" "──────────────────────────────────────────────────────────────────────────"
  last -a -n10
  # Final separator
  echo -e "${GRAY}╰──────────────────────────────────────────────────────────────────────────╯${RESET}"
  echo ""
}

alias sinfo=system_info
# Uncomment to show system information at terminal startup
#system_info
