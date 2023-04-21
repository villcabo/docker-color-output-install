# ==============================================================
# Docker
# ==============================================================
dps() {
    docker ps "$@" | docker-color-output
}
dpsf() {
    docker ps --format "table {{.ID}}\\t{{.Names}}\\t{{.Ports}}\\t{{.Status}}\\t{{.Image}}" "$@" | docker-color-output
}
di() {
    docker images "$@" | docker-color-output
}
dl() {
    docker logs -f "$@" | docker-color-output
}
dlt() {
    docker logs --tail 50 -f "$@" | docker-color-output
}

# ==============================================================
# Docker Compose
# ==============================================================
dc() {
    docker compose "$@"
}
dcl() {
    docker compose logs -f "$@" | docker-color-output
}
dclt() {
    docker compose logs --tail 100 -f "$@" | docker-color-output
}
dcps() {
    docker compose ps "$@" | docker-color-output
}
