#!/bin/bash

# Script para instalar node_exporter como servicio systemd
# Uso: ./install_node_exporter.sh [version]
# Si no se especifica la versión, se usará la 1.9.0 por defecto

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

# Verificar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}${BOLD}✖ Error: Este script debe ejecutarse como root o con sudo ${NORMAL}"
  exit 1
fi

# Determinar la versión a instalar
VERSION=${1:-"1.9.0"}
ARCH="linux-amd64"
DOWNLOAD_URL="https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.${ARCH}.tar.gz"
TEMP_DIR=$(mktemp -d)
SERVICE_FILE="/etc/systemd/system/node_exporter.service"

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
echo -e "${BOLD}➔ Recargando systemd y habilitando servicio ${ITALIC}node_exporter${QUIT_ITALIC} ⏳...${NORMAL}"
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter
echo -e "${GREEN}${BOLD}✓ Servicio habilitado y iniciado $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
echo

# Verificar el estado del servicio
echo -e "${BOLD}➔ Verificando estado del servicio ${ITALIC}node_exporter${QUIT_ITALIC} ⏳...${NORMAL}"
systemctl status node_exporter --no-pager
echo

# Limpiar archivos temporales
echo -e "${BOLD}➔ Limpiando archivos temporales ⏳...${NORMAL}"
rm -rf "${TEMP_DIR}"
echo -e "${GREEN}${BOLD}✓ Archivos temporales eliminados $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
echo

echo -e "${GREEN}${BOLD}✅ Instalación completada exitosamente $(date "+%Y-%m-%d %H:%M:%S") ${NORMAL}"
echo -e "${BLUE}${BOLD}ℹ️ Node Exporter v${VERSION} está instalado y ejecutándose como servicio ${NORMAL}"
echo -e "${BLUE}${BOLD}🔍 Puedes comprobar las métricas en: ${UNDERLINE}http://localhost:9100/metrics${NORMAL}"
echo
