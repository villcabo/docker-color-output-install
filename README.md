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

**Codespace Basic**

```bash
cp ~/.bashrc ~/.bashrc.backup && wget -q -O ~/.bashrc https://raw.githubusercontent.com/villcabo/docker-color-output-install/main/bash_configuration/bash_codespace.sh && source ~/.bashrc
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

Con recarga de bash

```bash
wget -q -O - https://raw.githubusercontent.com/villcabo/docker-color-output/main/docker_configuration/docker-color-aliases_installers.sh | bash && source ~/.bashrc
```
## Recargar .bashrc o .zshrc

Después de la instalación, recarga tu archivo .bashrc para aplicar los cambios:

```bash
source ~/.bashrc
source ~/.zshrc
```
