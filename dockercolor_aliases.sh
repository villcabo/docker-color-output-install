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
dcps() {
    docker compose ps "$@" | docker-color-output
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
