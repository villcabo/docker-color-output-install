#!/usr/bin/env bash

# ==============================================================
# Docker
# ==============================================================
dps() {
    docker ps "$@" | docker-color-output
}
dps1() {
    docker ps --format "table {{.ID}}\\t{{.Names}}\\t{{.RunningFor}}\\t{{.Status}}\\t{{.Image}}" "$@" | docker-color-output
}
dpsports() {
    docker ps --format "table {{.ID}}\\t{{.Names}}\\t{{.Ports}}" "$@" | docker-color-output
}
di() {
    docker images "$@" | docker-color-output
}
ds() {
    docker stats "$@" | docker-color-output
}
ds1() {
    docker stats --no-stream "$@" | docker-color-output
}
dl() {
    docker logs -f "$@"
}
dlt() {
    docker logs --tail 100 -f "$@"
}
dlt300() {
    docker logs --tail 300 -f "$@"
}
dlt500() {
    docker logs --tail 500 -f "$@"
}

# ==============================================================
# Docker Compose
# ==============================================================
dc() {
    docker compose "$@"
}
dcup() {
    local PULL=false
    local FORCE=false
    local LOGS=false
    local OPTIND=1
    local opts=""

    # Procesar todas las opciones
    while getopts "pfl" opt; do
        case $opt in
            p) PULL=true ;;
            f) FORCE=true ;;
            l) LOGS=true ;;
            *) echo "Opción inválida: -$OPTARG" >&2; return 1 ;;
        esac
    done

    # Saltar las opciones procesadas para obtener los argumentos restantes
    shift $((OPTIND-1))

    # Construir las opciones para docker compose
    [[ "$PULL" == true ]] && opts+=" --pull always"
    [[ "$FORCE" == true ]] && opts+=" --force-recreate"

    # Ejecutar el comando docker compose up con las opciones correspondientes
    eval "docker compose up -d$opts $*"

    # Si se solicitaron logs, mostrarlos
    if [[ "$LOGS" == true ]]; then
        docker compose logs -f "$@"
    fi
}
dcps() {
    docker compose ps "$@" | docker-color-output
}
dcps1() {
    docker compose ps --format "table {{.Name}}\\t{{.Service}}\\t{{.RunningFor}}\\t{{.Status}}\\t{{.Image}}" "$@" | docker-color-output
}
dcpsports() {
    docker compose ps --format "table {{.Name}}\\t{{.Service}}\\t{{.Ports}}" "$@" | docker-color-output
}
dcs() {
    docker compose stats "$@" | docker-color-output
}
dcs1() {
    docker compose stats --no-stream "$@" | docker-color-output
}
dcl() {
    docker compose logs -f "$@"
}
dclt() {
    docker compose logs --tail 100 -f "$@"
}
dclt300() {
    docker compose logs --tail 300 -f "$@"
}
dclt500() {
    docker compose logs --tail 500 -f "$@"
}
