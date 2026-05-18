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

DEB_URL="https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.15/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb"
DEB_PATH="/root/cri-dockerd.deb"

need_download="true"
if [ -f "$DEB_PATH" ]; then
  # If the file exists, check whether it claims to be 0.3.15 (at least).
  # If metadata can't be read, re-download.
  if dpkg-deb -f "$DEB_PATH" Version >/dev/null 2>&1; then
    ver="$(dpkg-deb -f "$DEB_PATH" Version | head -n1 | tr -d '[:space:]')"
    case "$ver" in
      0.3.15*|0.3.16*|0.3.17*|0.3.18*|0.3.19*|0.3.2*|0.4.*|1.*)
        need_download="false"
        ;;
      *)
        echo "Existing $DEB_PATH version '$ver' is not acceptable; will re-download." >&2
        need_download="true"
        ;;
    esac
  else
    echo "Existing $DEB_PATH is not a readable .deb; will re-download." >&2
    need_download="true"
  fi
fi

if [ "$need_download" = "true" ]; then
  tmp="$(mktemp)"
  if curl -fsSL "$DEB_URL" -o "$tmp"; then
    mv -f "$tmp" "$DEB_PATH"
    chmod 0644 "$DEB_PATH"
    echo "Downloaded cri-dockerd deb to $DEB_PATH"
  else
    rm -f "$tmp"
    echo "Warning: could not download cri-dockerd .deb" >&2
  fi
else
  echo "Keeping existing $DEB_PATH"
fi

echo "Setup complete"
