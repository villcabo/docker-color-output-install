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
    docker compose up -d "$@"
}
dcuppull() {
    docker compose up -d --pull always "$@"
}
dcupforce() {
    docker compose up -d --force-recreate "$@"
}
dcuppullforce() {
    docker compose up -d --pull always --force-recreate "$@"
}
dcps() {
    docker compose ps "$@" | docker-color-output
}
dcps1() {
    docker compose ps --format "table {{.ID}}\\t{{.Names}}\\t{{.RunningFor}}\\t{{.Status}}\\t{{.Image}}" "$@" | docker-color-output
}
dcpsports() {
    docker compose ps --format "table {{.ID}}\\t{{.Names}}\\t{{.Ports}}" "$@" | docker-color-output
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
