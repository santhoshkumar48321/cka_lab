#!/usr/bin/env bash
set -euo pipefail

# ── Wait for Kubernetes API ──────────────────────────────────────────────────
wait_kube() {
  for i in $(seq 1 60); do
    if kubectl get ns >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  echo "Kubernetes API not ready after 60 seconds" >&2
  exit 1
}

wait_kube

# ── Install Docker if missing ────────────────────────────────────────────────
if ! command -v docker >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y docker.io
fi

# ── Start Docker daemon if not running ──────────────────────────────────────
if ! docker info >/dev/null 2>&1; then
  service docker start 2>/dev/null || \
    dockerd --host=unix:///var/run/docker.sock >/var/log/dockerd.log 2>&1 &
  sleep 5
fi

# ── Download cri-dockerd .deb (short name the lab expects) ──────────────────
DEB_URL="https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.15/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb"
DEB_PATH="/root/cri-dockerd.deb"

if [ ! -f "$DEB_PATH" ]; then
  curl -fsSL "$DEB_URL" -o "$DEB_PATH" || echo "Warning: could not download cri-dockerd .deb" >&2
fi

# ── Load br_netfilter so bridge sysctl keys exist ───────────────────────────
modprobe br_netfilter 2>/dev/null || true

echo "Setup complete"
