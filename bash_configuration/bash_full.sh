# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.

# Configuración de colores para prompt según usuario (root/no-root)
if [ $(id -u) -eq 0 ]; then
    # Usuario root - prompt en rojo
    PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    # Usuario normal - prompt en verde
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Configuración para dircolors (colores en ls)
export LS_OPTIONS='--color=auto'
eval "$(dircolors -b)"

# Alias comunes
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias la='ls $LS_OPTIONS -A'
alias l='ls $LS_OPTIONS -lA'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Algunos alias para evitar errores
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# Añadir directorios bin al PATH si existen
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Cargar aliases personalizados si existe el archivo
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Definir editor predeterminado
# export EDITOR=nano
export EDITOR=vim

# Mejorar el comando cd
# 'cd -' para volver al directorio anterior
# 'cd' solo para ir al directorio home
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Función para crear un directorio y entrar en él
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Historial: no guardar comandos duplicados y comandos que empiecen con espacio
HISTCONTROL=ignoreboth

# Tamaño del historial
HISTSIZE=1000
HISTFILESIZE=2000

# Añadir al historial, no sobrescribir
shopt -s histappend

# Comprobar tamaño de ventana después de cada comando
shopt -s checkwinsize

# Mejorar la experiencia de la terminal
shopt -s autocd      # Cambiar a un directorio con solo escribir su nombre
shopt -s cdspell     # Autocorregir errores tipográficos menores en cd
shopt -s dirspell    # Autocorregir errores tipográficos en nombres de directorios durante autocompletado
shopt -s globstar    # Habilitar patrón ** para que coincida con todos los archivos y directorios recursivamente

# Habilitar autocompletado si está disponible
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Alias adicionales útiles
alias update='sudo apt update && sudo apt upgrade'
alias free='free -h'
alias df='df -h'
alias du='du -h'
alias top='htop'  # Requiere instalar htop: sudo apt install htop
alias ports='netstat -tulanp'  # Muestra puertos abiertos
alias myip='curl -s https://ipinfo.io/ip || curl -s https://ifconfig.me'  # Muestra IP pública
alias clearhistory='history -c && history -w'  # Limpia el historial
alias path='echo -e ${PATH//:/\\n}'  # Muestra PATH en líneas separadas
alias weather='curl wttr.in'  # Muestra el clima actual (requiere conexión a internet)

# Historial con fecha y hora
export HISTTIMEFORMAT="%d/%m/%y %T "

# Función para buscar en el historial
function hg() {
    history | grep "$1"
}

# Función para extraer archivos comprimidos fácilmente
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' no puede ser extraído mediante extract()" ;;
    esac
  else
    echo "'$1' no es un archivo válido"
  fi
}

# Información del sistema en el inicio de la terminal
system_info() {
  # Colores
  local RED="\033[1;31m"
  local GREEN="\033[1;32m"
  local YELLOW="\033[1;33m"
  local BLUE="\033[1;34m"
  local PURPLE="\033[1;35m"
  local CYAN="\033[1;36m"
  local WHITE="\033[1;37m"
  local RESET="\033[0m"
  
  # Sistema y kernel
  echo -e "${BLUE}Sistema:${RESET} $(uname -o) $(uname -m)"
  echo -e "${RED}Kernel:${RESET} $(uname -r)"
  echo -e "${GREEN}Uptime:${RESET} $(uptime -p | sed 's/up //')"
  
  # Uso de memoria y disco
  echo -e "${YELLOW}Memoria:${RESET} $(free -h | awk '/^Mem:/ {print $3 " de " $2 " usado"}')"
  echo -e "${PURPLE}Disco:${RESET} $(df -h --output=used,size / | awk 'NR==2 {print $1 " de " $2 " usado"}')"
  
  # Carga del sistema
  echo -e "${CYAN}Carga:${RESET} $(cat /proc/loadavg | cut -d' ' -f1-3)"
  echo ""
}

# Descomentar para mostrar información del sistema al iniciar la terminal
# system_info

# Mejoras para git
if [ -f /usr/lib/git-core/git-sh-prompt ]; then
  . /usr/lib/git-core/git-sh-prompt
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  
  # Añadir información de git al prompt si estamos en un repositorio
  PS1_original=$PS1
  if [ $(id -u) -eq 0 ]; then
    # Usuario root - prompt en rojo
    PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)")\$ '
  else
    # Usuario normal - prompt en verde
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)")\$ '
  fi
fi
