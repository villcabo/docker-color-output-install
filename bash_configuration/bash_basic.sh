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

# Añadir ~/.local/bin al PATH si existe
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Cargar aliases personalizados si existe el archivo
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Historial: no guardar comandos duplicados y comandos que empiecen con espacio
HISTCONTROL=ignoreboth

# Tamaño del historial
HISTSIZE=1000
HISTFILESIZE=2000

# Añadir al historial, no sobrescribir
shopt -s histappend

# Comprobar tamaño de ventana después de cada comando
shopt -s checkwinsize

# Habilitar autocompletado si está disponible
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
