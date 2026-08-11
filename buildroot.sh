#!/bin/bash
set -e

BUILDER_UID="$(id -u)"
BUILDER_GID="$(id -g)"
CACHE_DIR="${CACHE_DIR:-./cache}"
BOARD="${1:-jethub_j310}"
shift 2>/dev/null || true

mkdir -p "${CACHE_DIR}"

if [ ! -f buildroot/Makefile ]; then
  git submodule update --init
fi

docker build -t jrescue-builder .

DOCKER_TTY=()
[ -t 0 ] && DOCKER_TTY=(-it)

docker run --rm "${DOCKER_TTY[@]}" \
  -v "$(pwd):/build" \
  -v "$(realpath "${CACHE_DIR}"):/cache" \
  -e BUILDER_UID="${BUILDER_UID}" \
  -e BUILDER_GID="${BUILDER_GID}" \
  jrescue-builder \
  make BUILDDIR=/build "${BOARD}" "$@"
