# ==============================================================
# Docker
# ==============================================================
dps() {
    docker ps "$@" | docker-color-output
}
dps1() {
    docker ps --format "table {{.ID}}\\t{{.Names}}\\t{{.Status}}\\t{{.Image}}" "$@" | docker-color-output
}
dpsports() {
    docker ps --format "table {{.ID}}\\t{{.Names}}\\t{{.Ports}}" "$@" | docker-color-output
}
di() {
    docker images "$@" | docker-color-output
}
dl() {
    docker logs -f "$@"
}
dlt100() {
    docker logs --tail 100 -f "$@"
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
dclt100() {
    docker compose logs --tail 100 -f "$@"
}
dcps() {
    docker compose ps "$@" | docker-color-output
}
