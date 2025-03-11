# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# bash theme - partly inspired by https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/robbyrussell.zsh-theme
__bash_prompt() {
  local userpart='`export XIT=$? \
    && [ "$EUID" -eq 0 ] && echo -n "\[\033[1;31m\]\u " || \
    ([ ! -z "${GITHUB_USER:-}" ] && echo -n "\[\033[0;32m\]@${GITHUB_USER:-} " || echo -n "\[\033[0;32m\]\u ") \
    && [ "$XIT" -ne "0" ] && echo -n "\[\033[1;31m\]➜" || echo -n "\[\033[0m\]➜"`'
  local gitbranch='`\
    if [ "$(git config --get devcontainers-theme.hide-status 2>/dev/null)" != 1 ] && [ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ]; then \
        export BRANCH="$(git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git --no-optional-locks rev-parse --short HEAD 2>/dev/null)"; \
        if [ "${BRANCH:-}" != "" ]; then \
            echo -n "\[\033[0;36m\](\[\033[1;31m\]${BRANCH:-}" \
            && if [ "$(git config --get devcontainers-theme.show-dirty 2>/dev/null)" = 1 ] && \
                git --no-optional-locks ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then \
                    echo -n " \[\033[1;33m\]✗"; \
            fi \
            && echo -n "\[\033[0;36m\]) "; \
        fi; \
    fi`'
  local lightblue='\[\033[1;34m\]'
  local removecolor='\[\033[0m\]'
  PS1="${userpart} ${lightblue}\w ${gitbranch}${removecolor}\$ "
  unset -f __bash_prompt
}
__bash_prompt
export PROMPT_DIRTRIM=4

# Check if the terminal is xterm
if [[ "$TERM" == "xterm" ]]; then
  # Function to set the terminal title to the current command
  preexec() {
    local cmd="${BASH_COMMAND}"
    echo -ne "\033]0;${USER}@${HOSTNAME}: ${cmd}\007"
  }

  # Function to reset the terminal title to the shell type after the command is executed
  precmd() {
    echo -ne "\033]0;${USER}@${HOSTNAME}: ${SHELL}\007"
  }

  # Trap DEBUG signal to call preexec before each command
  trap 'preexec' DEBUG

  # Append to PROMPT_COMMAND to call precmd before displaying the prompt
  PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }precmd"
fi

# Define default editor
export EDITOR=vim

# Improve terminal experience
shopt -s autocd   # Change to a directory by simply typing its name
shopt -s cdspell  # Autocorrect minor typos in cd commands
shopt -s dirspell # Autocorrect typos in directory names during autocompletion
shopt -s globstar # Enable ** pattern to match all files and directories recursively

# Additional useful aliases
alias free='free -h'
alias df='df -h'
alias du='du -h'
alias ports='netstat -tulanp'                                            # Shows open ports
alias myip='curl -s https://ipinfo.io/ip || curl -s https://ifconfig.me' # Shows public IP
alias myiplocal='hostname -I | awk "{print \$1}"'                        # Shows local IP
alias clearhistory='history -c && history -w'                            # Clear history
alias path='echo -e ${PATH//:/\\n}'                                      # Shows PATH in separate lines
alias weather='curl wttr.in'                                             # Shows current weather (requires internet connection)

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
  echo -e "${GRAY}╭─────────────────────── SYSTEM INFORMATION ───────────────────────╮${RESET}"

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
  printf "${GRAY}%-12s\n" "────────────────────────────────────────────────────────────────────"
  printf "${GRAY}%-12s %-20s %-15s %-15s\n" "  User" "   Date and Time" "  Origin" "     IP"
  printf "${GRAY}%-12s\n" "────────────────────────────────────────────────────────────────────"
  last -a | head -5 | awk '{printf "  %-12s  %-20s  %-15s  %-15s\n", $1, $4" "$5" "$6" "$7, $3, $10}'

  # Final separator
  echo -e "${GRAY}╰──────────────────────────────────────────────────────────────────╯${RESET}"
  echo ""
}

alias sinfo='system_info'
#system_info
