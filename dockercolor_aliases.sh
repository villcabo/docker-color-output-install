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
    docker logs -f "$@"
}
dlt() {
    docker logs --tail 500 -f "$@"
}

# ==============================================================
# Docker Compose
# ==============================================================
dc() {
    docker compose "$@"
}
dcl() {
    docker compose logs -f "$@"
}
dclt() {
    docker compose logs --tail 500 -f "$@"
}
dcps() {
    docker compose ps "$@" | docker-color-output
}
