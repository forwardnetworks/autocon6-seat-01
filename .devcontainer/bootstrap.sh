#!/usr/bin/env bash
# Prepare a workshop Codespace. Safe to re-run; prints no secret values.
set -euo pipefail
cd "$(dirname "$0")/.."

CONTAINERLAB_VERSION=0.79.0
NETLAB_VERSION=26.9
CEOS_IMAGE="${AUTOCON6_CEOS_IMAGE:-ghcr.io/forwardnetworks/autocon6-ceos:4.36.0.1F}"

step() { printf '\n== %s\n' "$*"; }

step "Python tools (uv, workshop CLI, netlab ${NETLAB_VERSION})"
command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
uv sync --frozen
uv tool install --quiet "networklab==${NETLAB_VERSION}"

step "containerlab ${CONTAINERLAB_VERSION}"
if ! containerlab version 2>/dev/null | grep -q "version: ${CONTAINERLAB_VERSION}"; then
  bash -c "$(curl -sL https://get.containerlab.dev)" -- -v "${CONTAINERLAB_VERSION}"
fi

step "cEOS image"
if ! docker image inspect ceos:4.36.0.1F >/dev/null 2>&1; then
  if [ -n "${AUTOCON6_REGISTRY_TOKEN:-}" ]; then
    printf '%s' "$AUTOCON6_REGISTRY_TOKEN" | docker login ghcr.io -u autocon6 --password-stdin >/dev/null
  elif [ -n "${GITHUB_TOKEN:-}" ]; then
    printf '%s' "$GITHUB_TOKEN" | docker login ghcr.io -u "${GITHUB_USER:-codespace}" --password-stdin >/dev/null || true
  fi
  docker pull --quiet "$CEOS_IMAGE"
  docker tag "$CEOS_IMAGE" ceos:4.36.0.1F
fi

step "Headless collector (matching the Forward server release)"
if [ -n "${FORWARD_URL:-}" ]; then
  .venv/bin/workshop collector || echo "collector download deferred: run 'workshop collector' after your seat secrets are set"
fi

step "Doctor"
.venv/bin/workshop doctor || true
