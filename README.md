# Docker Color Output Install

Este documento proporciona instrucciones para instalar y configurar Docker Color Output.

## Instalación

Para instalar Docker Color Output, ejecuta el siguiente comando, solo para este comando debes tener privilegios de `root`:

```bash
wget -q -O - https://raw.githubusercontent.com/villcabo/docker-color-output/main/docker-color_installers.sh | bash
```

## Configuración de Alias

Para instalar las configuraciones de alias, ejecuta el siguiente comando:

```bash
wget -q -O - https://raw.githubusercontent.com/villcabo/docker-color-output/main/docker-color-aliases_installers.sh | bash
```

Con recarga de bash

```bash
wget -q -O - https://raw.githubusercontent.com/villcabo/docker-color-output/main/docker-color-aliases_installers.sh | bash && source ~/.bashrc
```
## Recargar .bashrc

Después de la instalación, recarga tu archivo .bashrc para aplicar los cambios:

```bash
source ~/.bashrc
```
