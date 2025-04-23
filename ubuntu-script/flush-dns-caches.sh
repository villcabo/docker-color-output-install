#!/bin/bash

# Script para limpiar caché de DNS en Ubuntu 22.04+

echo "🧹 Limpiando caché de DNS del sistema..."
sudo resolvectl flush-caches
echo "✅ Caché DNS del sistema limpiada."

# Función para cerrar y limpiar caché de un navegador
limpiar_navegador() {
    local navegador=$1
    local rutas=("${!2}")

    echo "🧹 Limpiando caché de $navegador..."

    for ruta in "${rutas[@]}"; do
        if [ -d "$ruta" ]; then
            rm -rf "$ruta"
            echo "✅ Caché eliminada en: $ruta"
        fi
    done
}

# Detectar usuario actual si se ejecuta como sudo
USER_HOME=$(eval echo "~$SUDO_USER")

# Rutas de caché por navegador
chrome_cache=(
    "$USER_HOME/.cache/google-chrome/Default/Cache"
    "$USER_HOME/.config/google-chrome/Default/Code Cache"
)
chromium_cache=(
    "$USER_HOME/.cache/chromium/Default/Cache"
    "$USER_HOME/.config/chromium/Default/Code Cache"
)
brave_cache=(
    "$USER_HOME/.cache/BraveSoftware/Brave-Browser/Default/Cache"
    "$USER_HOME/.config/BraveSoftware/Brave-Browser/Default/Code Cache"
)
firefox_cache=($(find "$USER_HOME/.cache/mozilla/firefox/" -maxdepth 1 -type d -name "*.default*" 2>/dev/null))

# Limpiar navegadores
limpiar_navegador "Chrome" chrome_cache[@]
limpiar_navegador "Chromium" chromium_cache[@]
limpiar_navegador "Brave" brave_cache[@]

# Limpiar caché Firefox
echo "🧹 Limpiando caché de Firefox..."
for dir in "${firefox_cache[@]}"; do
    rm -rf "$dir/cache2"
    echo "✅ Caché eliminada en: $dir/cache2"
done

echo "✅ Limpieza completada."
