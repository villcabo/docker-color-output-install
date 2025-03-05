#!/usr/bin/env bash

# ==============================================================
# Docker
# ==============================================================
dps() {
    docker ps "$@" | docker-color-output -s
}
dps1() {
    docker ps --format "table {{.ID}}\\t{{.Names}}\\t{{.RunningFor}}\\t{{.Status}}\\t{{.Image}}" "$@" | docker-color-output -s
}
dpsports() {
    docker ps --format "table {{.ID}}\\t{{.Names}}\\t{{.Ports}}" "$@" | docker-color-output -s
}
di() {
    docker images "$@" | docker-color-output -s
}
ds() {
    docker stats "$@" | docker-color-output -s
}
ds1() {
    docker stats --no-stream "$@" | docker-color-output -s
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
    docker compose ps "$@" | docker-color-output -s
}
dcps1() {
    docker compose ps --format "table {{.Name}}\\t{{.Service}}\\t{{.RunningFor}}\\t{{.Status}}\\t{{.Image}}" "$@" | docker-color-output -s
}
dcpsports() {
    docker compose ps --format "table {{.Name}}\\t{{.Service}}\\t{{.Ports}}" "$@" | docker-color-output -s
}
dcs() {
    docker compose stats "$@" | docker-color-output -s
}
dcs1() {
    docker compose stats --no-stream "$@" | docker-color-output -s
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
