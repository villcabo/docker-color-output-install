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

# Nuevos alias para docker exec
dex() {
    docker exec -it "$@"
}
dexsh() {
    docker exec -it "$1" sh
}
dexbash() {
    docker exec -it "$1" bash
}

# Alias adicionales útiles
drm() {
    docker rm "$@"
}
drmi() {
    docker rmi "$@"
}
dstop() {
    docker stop "$@"
}
dstart() {
    docker start "$@"
}
drestart() {
    docker restart "$@"
}
dinspect() {
    docker inspect "$@"
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

# Nuevos alias para docker compose exec
dcex() {
    docker compose exec "$@"
}
dcexsh() {
    docker compose exec "$1" sh
}
dcexbash() {
    docker compose exec "$1" bash
}

# Alias adicionales para docker compose
dcdown() {
    docker compose down "$@"
}
dcstop() {
    docker compose stop "$@"
}
dcstart() {
    docker compose start "$@"
}
dcrestart() {
    docker compose restart "$@"
}
dcpull() {
    docker compose pull "$@"
}
dcbuild() {
    docker compose build "$@"
}

# ==============================================================
# Funciones de Autocompletado
# ==============================================================

# Función auxiliar para obtener nombres de contenedores
_get_docker_containers() {
    docker ps --format "{{.Names}}" 2>/dev/null
}

# Función auxiliar para obtener nombres de servicios de compose
_get_compose_services() {
    if [[ -f docker-compose.yml ]] || [[ -f docker-compose.yaml ]] || [[ -f compose.yml ]] || [[ -f compose.yaml ]]; then
        docker compose ps --services 2>/dev/null
    fi
}

# Autocompletado para comandos docker exec
_docker_exec_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local containers=$(_get_docker_containers)
    COMPREPLY=($(compgen -W "${containers}" -- ${cur}))
}

# Autocompletado para comandos docker compose exec
_docker_compose_exec_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local services=$(_get_compose_services)
    COMPREPLY=($(compgen -W "${services}" -- ${cur}))
}

# Autocompletado para comandos docker generales (contenedores)
_docker_containers_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local containers=$(_get_docker_containers)
    COMPREPLY=($(compgen -W "${containers}" -- ${cur}))
}

# Autocompletado para comandos docker compose generales (servicios)
_docker_compose_services_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local services=$(_get_compose_services)
    COMPREPLY=($(compgen -W "${services}" -- ${cur}))
}

# Registrar autocompletado para alias de docker exec
complete -F _docker_exec_completion dex
complete -F _docker_exec_completion dexsh
complete -F _docker_exec_completion dexbash

# Registrar autocompletado para alias de docker compose exec
complete -F _docker_compose_exec_completion dcex
complete -F _docker_compose_exec_completion dcexsh
complete -F _docker_compose_exec_completion dcexbash

# Registrar autocompletado para otros alias de docker
complete -F _docker_containers_completion dl
complete -F _docker_containers_completion dlt
complete -F _docker_containers_completion dlt300
complete -F _docker_containers_completion dlt500
complete -F _docker_containers_completion drm
complete -F _docker_containers_completion dstop
complete -F _docker_containers_completion dstart
complete -F _docker_containers_completion drestart
complete -F _docker_containers_completion dinspect

# Registrar autocompletado para otros alias de docker compose
complete -F _docker_compose_services_completion dcl
complete -F _docker_compose_services_completion dclt
complete -F _docker_compose_services_completion dclt300
complete -F _docker_compose_services_completion dclt500
complete -F _docker_compose_services_completion dcstop
complete -F _docker_compose_services_completion dcstart
complete -F _docker_compose_services_completion dcrestart

# ==============================================================
# Funciones auxiliares adicionales
# ==============================================================

# Función para mostrar ayuda de los alias
docker_aliases_help() {
    echo "=== Docker Aliases ==="
    echo "dps          - docker ps con colores"
    echo "dps1         - docker ps formato compacto"
    echo "dpsports     - docker ps mostrando puertos"
    echo "di           - docker images con colores"
    echo "ds/ds1       - docker stats (continuo/una vez)"
    echo "dl           - docker logs -f"
    echo "dlt/dlt300/dlt500 - docker logs con tail"
    echo "dex          - docker exec -it"
    echo "dexsh/dexbash - docker exec con shell específico"
    echo "drm/drmi     - docker rm/rmi"
    echo "dstop/dstart/drestart - control de contenedores"
    echo ""
    echo "=== Docker Compose Aliases ==="
    echo "dc           - docker compose"
    echo "dcup [-pfl]  - docker compose up con opciones"
    echo "dcps/dcps1/dcpsports - docker compose ps variantes"
    echo "dcs/dcs1     - docker compose stats"
    echo "dcl/dclt     - docker compose logs"
    echo "dcex         - docker compose exec"
    echo "dcexsh/dcexbash - docker compose exec con shell"
    echo "dcdown/dcstop/dcstart/dcrestart - control de servicios"
    echo "dcpull/dcbuild - docker compose pull/build"
}

# Alias para la ayuda
alias dhelp='docker_aliases_help'
