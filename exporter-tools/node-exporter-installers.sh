#!/bin/bash

# Script para instalar node_exporter como servicio systemd
# Uso:
#   ./install_node_exporter.sh [-v versión] [--uninstall] [--bin-only]
#   Ejemplo: ./install_node_exporter.sh -v 1.9.0
#   Ejemplo: ./install_node_exporter.sh --uninstall
#   Ejemplo: ./install_node_exporter.sh --bin-only

# Color codes for logging
NORMAL='\033[0m'
BOLD='\033[1m'
ITALIC='\033[3m'
QUIT_ITALIC='\033[23m'
UNDERLINE='\033[4m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables por defecto
VERSION="1.9.0"
ARCH="linux-amd64"
SERVICE_FILE="/etc/systemd/system/node-exporter.service"
UNINSTALL=false
BIN_ONLY=false

# Función para mostrar ayuda
mostrar_ayuda() {
    echo -e "${BOLD}Uso:${NORMAL} $0 [OPCIONES]"
    echo -e ""
    echo -e "${BOLD}Opciones:${NORMAL}"
    echo -e "  -h, --help       Muestra esta ayuda"
    echo -e "  -v, --version    Especifica la versión de node_exporter (default: 1.9.0)"
    echo -e "  --uninstall      Desinstala node_exporter"
    echo -e "  --bin-only       Instala solo el binario de node_exporter"
    echo -e ""
    echo -e "${BOLD}Ejemplos:${NORMAL}"
    echo -e "  $0               Instala node_exporter v1.9.0"
    echo -e "  $0 -v 1.8.0      Instala node_exporter v1.8.0"
    echo -e "  $0 --uninstall   Desinstala node_exporter"
    echo -e "  $0 --bin-only    Instala solo el binario de node_exporter"
    exit 0
}

# Función para desinstalar node_exporter
desinstalar_node_exporter() {
    echo -e "${BLUE}${BOLD}🗑️ Desinstalando ${ITALIC}node_exporter${QUIT_ITALIC} $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Detener el servicio si está en ejecución
    if systemctl is-active --quiet node_exporter; then
        echo -e "${BOLD}➔ Deteniendo servicio ${ITALIC}node_exporter${QUIT_ITALIC} ⏳...${NORMAL}"
        systemctl stop node_exporter
        echo -e "${GREEN}${BOLD}✓ Servicio detenido $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        echo
    fi

    # Deshabilitar el servicio
    if systemctl is-enabled --quiet node_exporter; then
        echo -e "${BOLD}➔ Deshabilitando servicio ${ITALIC}node_exporter${QUIT_ITALIC} ⏳...${NORMAL}"
        systemctl disable node_exporter
        echo -e "${GREEN}${BOLD}✓ Servicio deshabilitado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        echo
    fi

    # Eliminar archivo de servicio
    if [ -f "${SERVICE_FILE}" ]; then
        echo -e "${BOLD}➔ Eliminando archivo de servicio ${ITALIC}${SERVICE_FILE}${QUIT_ITALIC} ⏳...${NORMAL}"
        rm -f "${SERVICE_FILE}"
        systemctl daemon-reload
        echo -e "${GREEN}${BOLD}✓ Archivo de servicio eliminado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        echo
    fi

    # Eliminar binario
    if [ -f "/usr/local/bin/node_exporter" ]; then
        echo -e "${BOLD}➔ Eliminando binario ${ITALIC}/usr/local/bin/node_exporter${QUIT_ITALIC} ⏳...${NORMAL}"
        rm -f /usr/local/bin/node_exporter
        echo -e "${GREEN}${BOLD}✓ Binario eliminado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        echo
    fi

    # Preguntar si desea eliminar el usuario
    echo -e "${YELLOW}${BOLD}❓ ¿Desea eliminar el usuario node_exporter? [s/N] ${NORMAL}"
    read -r respuesta
    if [[ "$respuesta" =~ ^[Ss]$ ]]; then
        echo -e "${BOLD}➔ Eliminando usuario ${ITALIC}node_exporter${QUIT_ITALIC} ⏳...${NORMAL}"
        userdel node_exporter
        echo -e "${GREEN}${BOLD}✓ Usuario eliminado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        echo
    fi

    echo -e "${GREEN}${BOLD}✅ Desinstalación completada exitosamente $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    exit 0
}

# Función para instalar solo el binario de node_exporter
instalar_binario_node_exporter() {
    DOWNLOAD_URL="https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.${ARCH}.tar.gz"
    TEMP_DIR=$(mktemp -d)

    echo -e "${BLUE}${BOLD}⚙️ Instalando binario de ${ITALIC}node_exporter v${VERSION}${QUIT_ITALIC} $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Descargar el archivo
    echo -e "${BOLD}➔ Descargando ${ITALIC}node_exporter${QUIT_ITALIC} desde ${UNDERLINE}${DOWNLOAD_URL}${NORMAL} ⏳..."
    wget -q --show-progress -O "${TEMP_DIR}/node_exporter.tar.gz" "${DOWNLOAD_URL}"

    if [ $? -ne 0 ]; then
        echo -e "${RED}${BOLD}✖ Error: No se pudo descargar node_exporter. Verifique la versión y su conexión a internet. $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        rm -rf "${TEMP_DIR}"
        exit 1
    fi
    echo -e "${GREEN}${BOLD}✓ Descarga completada $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Descomprimir el archivo
    echo -e "${BOLD}➔ Descomprimiendo ${ITALIC}node_exporter${QUIT_ITALIC} ⏳...${NORMAL}"
    tar -xzf "${TEMP_DIR}/node_exporter.tar.gz" -C "${TEMP_DIR}"
    echo -e "${GREEN}${BOLD}✓ Descompresión completada $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Eliminar el binario existente si existe
    if [ -f "/usr/local/bin/node_exporter" ]; then
        echo -e "${BOLD}➔ Eliminando binario ${ITALIC}/usr/local/bin/node_exporter${QUIT_ITALIC} existente ⏳...${NORMAL}"
        rm -f /usr/local/bin/node_exporter
        echo -e "${GREEN}${BOLD}✓ Binario eliminado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        echo
    fi

    # Mover el binario a /usr/local/bin
    echo -e "${BOLD}➔ Instalando binario en ${ITALIC}/usr/local/bin${QUIT_ITALIC} ⏳...${NORMAL}"
    cp "${TEMP_DIR}/node_exporter-${VERSION}.${ARCH}/node_exporter" /usr/local/bin/
    chmod +x /usr/local/bin/node_exporter
    echo -e "${GREEN}${BOLD}✓ Binario instalado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Limpiar archivos temporales
    echo -e "${BOLD}➔ Limpiando archivos temporales ⏳...${NORMAL}"
    rm -rf "${TEMP_DIR}"
    echo -e "${GREEN}${BOLD}✓ Archivos temporales eliminados $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    echo -e "${GREEN}${BOLD}✅ Instalación de binario completada exitosamente $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo -e "${BLUE}${BOLD}ℹ️ Binario de Node Exporter v${VERSION} instalado en /usr/local/bin ${NORMAL}"
    echo
}

# Función para instalar node_exporter completo
instalar_node_exporter() {
    DOWNLOAD_URL="https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.${ARCH}.tar.gz"
    TEMP_DIR=$(mktemp -d)

    echo -e "${BLUE}${BOLD}⚙️ Instalando ${ITALIC}node_exporter v${VERSION}${QUIT_ITALIC} $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Descargar el archivo
    echo -e "${BOLD}➔ Descargando ${ITALIC}node_exporter${QUIT_ITALIC} desde ${UNDERLINE}${DOWNLOAD_URL}${NORMAL} ⏳..."
    wget -q --show-progress -O "${TEMP_DIR}/node_exporter.tar.gz" "${DOWNLOAD_URL}"

    if [ $? -ne 0 ]; then
        echo -e "${RED}${BOLD}✖ Error: No se pudo descargar node_exporter. Verifique la versión y su conexión a internet. $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        rm -rf "${TEMP_DIR}"
        exit 1
    fi
    echo -e "${GREEN}${BOLD}✓ Descarga completada $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Descomprimir el archivo
    echo -e "${BOLD}➔ Descomprimiendo ${ITALIC}node_exporter${QUIT_ITALIC} ⏳...${NORMAL}"
    tar -xzf "${TEMP_DIR}/node_exporter.tar.gz" -C "${TEMP_DIR}"
    echo -e "${GREEN}${BOLD}✓ Descompresión completada $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Detener el servicio si está en ejecución
    if systemctl is-active --quiet node_exporter; then
        echo -e "${BOLD}➔ Deteniendo servicio ${ITALIC}node_exporter${QUIT_ITALIC} existente ⏳...${NORMAL}"
        systemctl stop node_exporter
        echo -e "${GREEN}${BOLD}✓ Servicio detenido $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        echo
    fi

    # Eliminar el binario existente si existe
    if [ -f "/usr/local/bin/node_exporter" ]; then
        echo -e "${BOLD}➔ Eliminando binario ${ITALIC}/usr/local/bin/node_exporter${QUIT_ITALIC} existente ⏳...${NORMAL}"
        rm -f /usr/local/bin/node_exporter
        echo -e "${GREEN}${BOLD}✓ Binario eliminado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        echo
    fi

    # Mover el binario a /usr/local/bin
    echo -e "${BOLD}➔ Instalando binario en ${ITALIC}/usr/local/bin${QUIT_ITALIC} ⏳...${NORMAL}"
    cp "${TEMP_DIR}/node_exporter-${VERSION}.${ARCH}/node_exporter" /usr/local/bin/
    chmod +x /usr/local/bin/node_exporter
    echo -e "${GREEN}${BOLD}✓ Binario instalado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Crear usuario para node_exporter si no existe
    if ! id -u node_exporter &>/dev/null; then
        echo -e "${BOLD}➔ Creando usuario ${ITALIC}node_exporter${QUIT_ITALIC} ⏳...${NORMAL}"
        useradd --no-create-home --shell /bin/false node_exporter
        echo -e "${GREEN}${BOLD}✓ Usuario creado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        echo
    fi

    # Eliminar archivo de servicio existente
    if [ -f "${SERVICE_FILE}" ]; then
        echo -e "${BOLD}➔ Eliminando archivo de servicio ${ITALIC}${SERVICE_FILE}${QUIT_ITALIC} existente ⏳...${NORMAL}"
        rm -f "${SERVICE_FILE}"
        echo -e "${GREEN}${BOLD}✓ Archivo de servicio eliminado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
        echo
    fi

    # Crear archivo de servicio systemd
    echo -e "${BOLD}➔ Creando archivo de servicio ${ITALIC}${SERVICE_FILE}${QUIT_ITALIC} ⏳...${NORMAL}"
    cat > "${SERVICE_FILE}" << EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/node_exporter
SuccessExitStatus=143
TimeoutStopSec=10
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

EOF
    echo -e "${GREEN}${BOLD}✓ Archivo de servicio creado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Recargar systemd y habilitar el servicio
    echo -e "${BOLD}➔ Recargando systemd y habilitando servicio ${ITALIC}node-exporter${QUIT_ITALIC} ⏳...${NORMAL}"
    systemctl daemon-reload
    systemctl enable node-exporter
    systemctl start node-exporter
    echo -e "${GREEN}${BOLD}✓ Servicio habilitado y iniciado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    # Verificar el estado del servicio
    echo -e "${BOLD}➔ Verificando estado del servicio ${ITALIC}node-exporter${QUIT_ITALIC} ⏳...${NORMAL}"
    systemctl status node-exporter --no-pager
    echo

    # Limpiar archivos temporales
    echo -e "${BOLD}➔ Limpiando archivos temporales ⏳...${NORMAL}"
    rm -rf "${TEMP_DIR}"
    echo -e "${GREEN}${BOLD}✓ Archivos temporales eliminados $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo

    echo -e "${GREEN}${BOLD}✅ Instalación completada exitosamente $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    echo -e "${BLUE}${BOLD}ℹ️ Node Exporter v${VERSION} está instalado y ejecutándose como servicio ${NORMAL}"
    SERVER_IP=$(hostname -I | awk '{print $1}')
    echo -e "${BLUE}${BOLD}🔍 Puedes comprobar las métricas en: ${UNDERLINE}http://${SERVER_IP}:9100/metrics${NORMAL}"
    echo
}

# Verificar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}${BOLD}✖ Error: Este script debe ejecutarse como root o con sudo $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
    exit 1
fi

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            mostrar_ayuda
            ;;
        -v|--version)
            if [[ -z "$2" || "$2" == -* ]]; then
                echo -e "${RED}${BOLD}✖ Error: La opción $1 requiere un argumento. $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
                exit 1
            fi
            VERSION="$2"
            shift 2
            ;;
        --uninstall)
            UNINSTALL=true
            shift
            ;;
        --bin-only)
            BIN_ONLY=true
            shift
            ;;
        *)
            echo -e "${RED}${BOLD}✖ Error: Opción desconocida: $1 $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
            mostrar_ayuda
            ;;
    esac
done

# Ejecutar la función correspondiente
if [ "$UNINSTALL" = true ]; then
    desinstalar_node_exporter
elif [ "$BIN_ONLY" = true ]; then
    instalar_binario_node_exporter
else
    instalar_node_exporter
fi
