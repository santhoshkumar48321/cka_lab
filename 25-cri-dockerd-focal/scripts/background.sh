#!/usr/bin/env bash
set -euo pipefail

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

if ! command -v docker >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y docker.io
fi

if ! docker info >/dev/null 2>&1; then
  service docker start 2>/dev/null || \
    dockerd --host=unix:///var/run/docker.sock >/var/log/dockerd.log 2>&1 &
  sleep 5
fi

DEB_URL="https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.15/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb"
DEB_PATH="/root/cri-dockerd.deb"

if [ ! -f "$DEB_PATH" ]; then
  curl -fsSL "$DEB_URL" -o "$DEB_PATH" || echo "Warning: could not download cri-dockerd .deb" >&2
fi

if ! command -v cri-dockerd >/dev/null 2>&1; then
  dpkg -i "$DEB_PATH" >/dev/null 2>&1 || apt-get -f install -y
fi

systemctl enable --now cri-docker.service >/dev/null 2>&1 || true
systemctl enable --now cri-docker.socket >/dev/null 2>&1 || true

sysctl -w net.bridge.bridge-nf-call-iptables=1 >/dev/null 2>&1 || true
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true
sysctl -w net.ipv6.conf.all.forwarding=1 >/dev/null 2>&1 || true

echo "Setup complete"
