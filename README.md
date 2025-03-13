# Bash Configuration

## Instalación

**Basic**

```bash
cp ~/.bashrc ~/.bashrc.backup && wget -q -O ~/.bashrc https://raw.githubusercontent.com/villcabo/docker-color-output-install/main/bash_configuration/bash_basic.sh && source ~/.bashrc
```

**Full**

```bash
cp ~/.bashrc ~/.bashrc.backup && wget -q -O ~/.bashrc https://raw.githubusercontent.com/villcabo/docker-color-output-install/main/bash_configuration/bash_full.sh && source ~/.bashrc
```

**Codespace Full**

```bash
cp ~/.bashrc ~/.bashrc.backup && wget -q -O ~/.bashrc https://raw.githubusercontent.com/villcabo/docker-color-output-install/main/bash_configuration/bash_codespace_full.sh && source ~/.bashrc
```

# Docker Color Output Install

Este documento proporciona instrucciones para instalar y configurar Docker Color Output.

## Instalación

Para instalar Docker Color Output, ejecuta el siguiente comando, solo para este comando debes tener privilegios de `root`:

**Para versiones de docker 28 hacia arriba utilize:**

```bash
wget -q -O - https://raw.githubusercontent.com/villcabo/docker-color-output/main/docker_configuration/docker-color_installers.sh | bash
```

**Para versiones de docker menores a la 28 utilize este:**

```bash
wget -q -O - https://raw.githubusercontent.com/villcabo/docker-color-output/main/docker_configuration/docker-color_installers.sh | bash -s -- -v 2.5.1
```

## Configuración de Alias

Para instalar las configuraciones de alias, ejecuta el siguiente comando:

```bash
wget -q -O - https://raw.githubusercontent.com/villcabo/docker-color-output/main/docker_configuration/docker-color-aliases_installers.sh | bash
```

**Con recarga de bash**

```bash
wget -q -O - https://raw.githubusercontent.com/villcabo/docker-color-output/main/docker_configuration/docker-color-aliases_installers.sh | bash && source ~/.bashrc
```
## Recargar .bashrc o .zshrc

Después de la instalación, recarga tu archivo .bashrc para aplicar los cambios:

```bash
source ~/.bashrc
```

```bash
source ~/.zshrc
```

# TMUX Configuration

## Instalacion

Instalacion configuration de **TMUX**

```bash
wget -q https://raw.githubusercontent.com/villcabo/docker-color-output-install/main/tmux_configuration/tmux.conf -O ~/.tmux.conf
```

Tmux Plugin Manager **TPM**

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

**Todo en un solo comando**

```bash
wget -q https://raw.githubusercontent.com/villcabo/docker-color-output-install/main/tmux_configuration/tmux.conf -O ~/.tmux.conf && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```


Para recargar la configuracion, debe iniciar **tmux** y teclear **ctrl + A shit I**

**En caso de que tmux ya se este ejecutando, puede utilizar este comando para recargar la configuracion**
```
tmux source ~/.tmux.conf
```

Si desea customizar el tema vaya al siguiente link:
- [Tokyo Night Tmux (DEFAULT)](https://github.com/janoamaral/tokyo-night-tmux?tab=readme-ov-file)
- [Tokyo Night Tmux Theme](https://github.com/fabioluciano/tmux-tokyo-night?tab=readme-ov-file)

# BANNER CONFIGURATION

Puede utilizar este sitio para generar texto:
- [Doom](https://patorjk.com/software/taag/#p=display&f=Doom&t=YOUR%20SERVER%0ANAME)
- [Big](https://patorjk.com/software/taag/#p=display&f=Big&t=YOUR%20SERVER%0ANAME)

Modifique el archivo **motd**

```bash
vim /etc/motd
```
