#!/usr/bin/env bash

# ==============================================================
# Docker Aliases - Versión Mejorada y Simplificada
# ==============================================================

# Función principal para docker con subcomandos
d() {
    case "$1" in
        # Básicos
        ps|p)     shift; docker ps "$@" | docker-color-output ;;
        ps1|p1)   shift; docker ps --format "table {{.ID}}\\t{{.Names}}\\t{{.RunningFor}}\\t{{.Status}}\\t{{.Image}}" "$@" | docker-color-output ;;
        psp)      shift; docker ps --format "table {{.ID}}\\t{{.Names}}\\t{{.Ports}}" "$@" | docker-color-output ;;
        images|i) shift; docker images "$@" | docker-color-output ;;

        # Stats y logs
        stats|s)  shift; docker stats "$@" | docker-color-output ;;
        s1)       shift; docker stats --no-stream "$@" | docker-color-output ;;
        logs|l)   shift; docker logs -f "$@" ;;
        l100)     shift; docker logs --tail 100 -f "$@" ;;
        l300)     shift; docker logs --tail 300 -f "$@" ;;
        l500)     shift; docker logs --tail 500 -f "$@" ;;

        # Exec (más simple)
        x)        shift; docker exec -it "$@" ;;
        sh)       shift; docker exec -it "$1" sh ;;
        bash)     shift; docker exec -it "$1" bash ;;

        # Control de contenedores
        start)    shift; docker start "$@" ;;
        stop)     shift; docker stop "$@" ;;
        restart)  shift; docker restart "$@" ;;
        rm)       shift; docker rm "$@" ;;
        rmi)      shift; docker rmi "$@" ;;
        kill)     shift; docker kill "$@" ;;

        # Información
        inspect)  shift; docker inspect "$@" ;;
        top)      shift; docker top "$@" ;;

        # Limpieza
        prune|pr)    docker system prune -f ;;
        prunea|prf)   docker system prune -af ;;
        pruneima|pri) docker image prune -f ;;
        prunevol|prv) docker volume prune -f ;;
        prunenet|prn) docker network prune -f ;;

        # Ayuda
        help|h)   _docker_help ;;

        # Por defecto, pasar comando directo a docker
        *)        docker "$@" ;;
    esac
}

# Función principal para docker compose con subcomandos
dc() {
    case "$1" in
        # Up con opciones inteligentes
        up|u)
            shift
            local opts=""
            local show_logs=false
            while [[ $1 == -* ]]; do
                local flags="${1#-}"
                for ((i=0; i<${#flags}; i++)); do
                    case "${flags:$i:1}" in
                        p) opts+=" --pull always" ;;
                        f) opts+=" --force-recreate" ;;
                        b) opts+=" --build" ;;
                        l) show_logs=true ;;
                    esac
                done
                shift
            done
            if eval "docker compose up -d$opts $*"; then
                if [[ "$show_logs" == true ]]; then
                    docker compose logs -f "$@"
                fi
            fi
            ;;

        # Up con logs automáticos
        ul)       shift; docker compose up -d "$@" && docker compose logs -f "$@" ;;

        # Básicos
        ps|p)     shift; docker compose ps "$@" | docker-color-output ;;
        ps1|p1)   shift; docker compose ps --format "table {{.Name}}\\t{{.Service}}\\t{{.RunningFor}}\\t{{.Status}}\\t{{.Image}}" "$@" | docker-color-output ;;
        psp)      shift; docker compose ps --format "table {{.Name}}\\t{{.Service}}\\t{{.Ports}}" "$@" | docker-color-output ;;

        # Stats y logs
        stats|s)  shift; docker compose stats "$@" | docker-color-output ;;
        s1)       shift; docker compose stats --no-stream "$@" | docker-color-output ;;
        logs|l)   shift; docker compose logs --tail 100 -f "$@" ;;
        l100)     shift; docker compose logs --tail 100 -f "$@" ;;
        l300)     shift; docker compose logs --tail 300 -f "$@" ;;
        l500)     shift; docker compose logs --tail 500 -f "$@" ;;

        # Exec (más simple)
        x)        shift; docker compose exec "$@" ;;
        sh)       shift; docker compose exec "$1" sh ;;
        bash)     shift; docker compose exec "$1" bash ;;

        # Control de servicios
        down|d)   shift; docker compose down "$@" ;;
        start)    shift; docker compose start "$@" ;;
        stop)     shift; docker compose stop "$@" ;;
        restart)  shift; docker compose restart "$@" ;;

        # Build y pull
        build|b)  shift; docker compose build "$@" ;;
        pull)     shift; docker compose pull "$@" ;;

        # Ayuda
        help|h)   _compose_help ;;

        # Por defecto, pasar comando directo a docker compose
        *)        docker compose "$@" ;;
    esac
}

# ==============================================================
# Aliases cortos adicionales (backward compatibility)
# ==============================================================

# Los más usados como aliases independientes
alias dps='d ps'
alias dps1='d ps1'
alias di='d images'
alias dl='d logs'
alias dlt='d l100'
alias dpri='d image prune'
alias ds='d stats'

alias dcup='dc up   '
alias dcps='dc ps'
alias dcl='dc logs'
alias dclt='dc l100'
alias dcdown='dc down'
alias dcs='dc stats'

# Exec shortcuts (muy comunes)
alias dx='d x'
alias dcx='dc x'

# ==============================================================
# Smart Functions - Funciones Inteligentes
# ==============================================================

# Función para ejecutar comando en el primer contenedor que coincida
dq() {
    local container=$(docker ps --format "{{.Names}}" | grep -i "$1" | head -1)
    if [[ -n "$container" ]]; then
        echo "→ Ejecutando en: $container"
        shift
        docker exec -it "$container" "$@"
    else
        echo "❌ No se encontró contenedor que coincida con: $1"
        return 1
    fi
}

# Función para ejecutar comando en el primer servicio que coincida
dcq() {
    if [[ ! -f docker-compose.yml ]] && [[ ! -f docker-compose.yaml ]] && [[ ! -f compose.yml ]] && [[ ! -f compose.yaml ]]; then
        echo "❌ No hay archivo compose en este directorio"
        return 1
    fi

    local service=$(docker compose ps --services | grep -i "$1" | head -1)
    if [[ -n "$service" ]]; then
        echo "→ Ejecutando en servicio: $service"
        shift
        docker compose exec "$service" "$@"
    else
        echo "❌ No se encontró servicio que coincida con: $1"
        return 1
    fi
}

# Función para mostrar estado rápido
dstatus() {
    echo "=== CONTAINERS ==="
    docker ps --format "table {{.Names}}\\t{{.Status}}\\t{{.Ports}}" | docker-color-output

    if [[ -f docker-compose.yml ]] || [[ -f docker-compose.yaml ]] || [[ -f compose.yml ]] || [[ -f compose.yaml ]]; then
        echo -e "\n=== COMPOSE SERVICES ==="
        docker compose ps --format "table {{.Service}}\\t{{.Status}}\\t{{.Ports}}" | docker-color-output
    fi
}

# Función para limpiar todo de una vez
dcleanup() {
    echo "🧹 Limpiando Docker..."
    docker system prune -f
    docker volume prune -f
    docker network prune -f
    echo "✅ Limpieza completada"
}

# ==============================================================
# Autocompletado Mejorado
# ==============================================================

_get_docker_containers() {
    docker ps --format "{{.Names}}" 2>/dev/null
}

_get_compose_services() {
    if [[ -f docker-compose.yml ]] || [[ -f docker-compose.yaml ]] || [[ -f compose.yml ]] || [[ -f compose.yaml ]]; then
        docker compose ps --services 2>/dev/null
    fi
}

# Autocompletado inteligente para función d()
_d_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ ${COMP_CWORD} == 1 ]]; then
        # Primeros argumentos - subcomandos
        local commands="ps p ps1 p1 psp images i stats s s1 logs l l100 l300 l500 x sh bash start stop restart rm rmi kill inspect top prune prunea prunevol prunenet help h"
        COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
    else
        # Segundos argumentos - contenedores
        case "$prev" in
            x|sh|bash|logs|l|l100|l300|l500|start|stop|restart|rm|inspect|top)
                local containers=$(_get_docker_containers)
                COMPREPLY=($(compgen -W "${containers}" -- ${cur}))
                ;;
        esac
    fi
}

# Autocompletado inteligente para función dc()
_dc_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local command=""
    local has_flags=false

    # Encontrar el comando principal (ignorando flags)
    for ((i=1; i<COMP_CWORD; i++)); do
        if [[ "${COMP_WORDS[i]}" != -* ]]; then
            command="${COMP_WORDS[i]}"
            break
        fi
    done

    # Verificar si ya hay flags en la línea de comando
    for ((i=1; i<COMP_CWORD; i++)); do
        if [[ "${COMP_WORDS[i]}" == -* ]]; then
            has_flags=true
            break
        fi
    done

    if [[ ${COMP_CWORD} == 1 ]]; then
        # Primeros argumentos - subcomandos
        local commands="up u ul ps p ps1 p1 psp stats s s1 logs l l100 l300 l500 x sh bash down d start stop restart build b pull help h"
        COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
    elif [[ "$cur" == -* ]]; then
        # Autocompletar flags para comandos que los soportan
        case "$command" in
            up|u|ul)
                local flags="-p -l -f -b"
                # Obtener flags ya usados para evitar duplicados
                local used_flags=""
                for ((i=1; i<COMP_CWORD; i++)); do
                    if [[ "${COMP_WORDS[i]}" == -* ]]; then
                        used_flags+="${COMP_WORDS[i]} "
                    fi
                done

                # Filtrar flags ya usados
                local available_flags=""
                for flag in $flags; do
                    if [[ ! "$used_flags" =~ $flag ]]; then
                        available_flags+="$flag "
                    fi
                done

                COMPREPLY=($(compgen -W "${available_flags}" -- ${cur}))
                ;;
        esac
    else
        # Autocompletar servicios después de comandos y flags
        case "$command" in
            x|sh|bash|logs|l|l100|l300|l500|start|stop|restart|up|u|ul|down|d|build|b)
                # Solo completar servicios si no estamos completando un flag
                if [[ "$prev" != -* ]] || [[ "$has_flags" == true ]]; then
                    local services=$(_get_compose_services)
                    COMPREPLY=($(compgen -W "${services}" -- ${cur}))
                fi
                ;;
        esac
    fi
}

# Autocompletado para funciones quick
_dq_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local containers=$(_get_docker_containers)
    COMPREPLY=($(compgen -W "${containers}" -- ${cur}))
}

_dcq_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local services=$(_get_compose_services)
    COMPREPLY=($(compgen -W "${services}" -- ${cur}))
}

_dcdown_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local services=$(_get_compose_services)
    COMPREPLY=($(compgen -W "${services}" -- ${cur}))
}

_dcl_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local services=$(_get_compose_services)
    COMPREPLY=($(compgen -W "${services}" -- ${cur}))
}

_dcx_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local services=$(_get_compose_services)
    COMPREPLY=($(compgen -W "${services}" -- ${cur}))
}

_dx_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local containers=$(_get_docker_containers)
    COMPREPLY=($(compgen -W "${containers}" -- ${cur}))
}

_dl_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local containers=$(_get_docker_containers)
    COMPREPLY=($(compgen -W "${containers}" -- ${cur}))
}

# Registrar autocompletados para funciones principales
complete -F _d_completion d
complete -F _dc_completion dc
complete -F _dq_completion dq
complete -F _dcq_completion dcq

# Registrar autocompletados para aliases específicos
complete -F _dc_completion dcup
complete -F _dcdown_completion dcdown
complete -F _dcl_completion dcl
complete -F _dcx_completion dcx
complete -F _dx_completion dx
complete -F _dl_completion dl

# ==============================================================
# Funciones de Ayuda
# ==============================================================

_docker_help() {
    cat << 'EOF'
🐳 Docker Helper (d)

BÁSICOS:
  d ps, d p          - Lista contenedores
  d ps1, d p1        - Lista formato compacto
  d psp              - Lista con puertos
  d images, d i      - Lista imágenes

LOGS & STATS:
  d logs, d l        - Logs en tiempo real
  d l100/l300/l500   - Logs con tail
  d stats, d s       - Stats en tiempo real
  d s1               - Stats una vez

EXEC:
  d x CONTAINER CMD  - Ejecutar comando
  d sh CONTAINER     - Shell sh
  d bash CONTAINER   - Shell bash

CONTROL:
  d start/stop/restart CONTAINER
  d rm/rmi           - Eliminar contenedor/imagen
  d kill             - Matar contenedor

LIMPIEZA:
  d prune            - Limpiar sistema
  d prunea           - Limpiar todo (aggressive)

QUICK:
  dq PATTERN CMD     - Ejecutar en primer contenedor que coincida
  dstatus            - Estado rápido
  dcleanup           - Limpieza completa

Ejemplos:
  d x web bash       - Bash en contenedor 'web'
  dq nginx ls        - ls en primer contenedor que contenga 'nginx'
EOF
}

_compose_help() {
    cat << 'EOF'
🐙 Docker Compose Helper (c)

BÁSICOS:
  dc up, dc u          - Levantar servicios
  dc up -p            - Up con pull
  dc up -f            - Up forzando recreación
  dc up -b            - Up con build
  dc ul               - Up + logs automáticos
  dc down, dc d        - Bajar servicios

ESTADO:
  dc ps, dc p          - Lista servicios
  dc ps1, dc p1        - Lista formato compacto
  dc psp              - Lista con puertos

LOGS & STATS:
  dc logs, dc l        - Logs en tiempo real
  dc l100/l300/l500   - Logs con tail
  dc stats, dc s       - Stats en tiempo real

EXEC:
  dc x SERVICE CMD    - Ejecutar comando
  dc sh SERVICE       - Shell sh
  dc bash SERVICE     - Shell bash

CONTROL:
  dc start/stop/restart SERVICE
  dc build, dc b       - Build servicios
  dc pull             - Pull imágenes

QUICK:
  dcq PATTERN CMD    - Ejecutar en primer servicio que coincida

Ejemplos:
  dc x api bash      - Bash en servicio 'api'
  dc ul web          - Up web service + logs
  dc up -fl          - Up forzando recreación + logs
  dc up -pl          - Up con pull + logs
  dcq data psql      - psql en primer servicio que contenga 'data'
EOF
}

# ==============================================================
# Alias de ayuda
# ==============================================================
alias dhelp='_docker_help'
alias dchelp='_compose_help'
alias dockerhelp='echo "Usa: dhelp (docker) o dchelp (compose)"'
