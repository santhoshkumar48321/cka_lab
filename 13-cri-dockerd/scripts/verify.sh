#!/usr/bin/env bash
set -euo pipefail

# Check binary exists
if ! command -v cri-dockerd >/dev/null 2>&1 && \
   ! test -x /usr/bin/cri-dockerd && \
   ! test -x /usr/local/bin/cri-dockerd; then
  echo "cri-dockerd binary not found (checked PATH, /usr/bin, /usr/local/bin)"
  exit 1
fi

# Check cri-docker.service is active
if ! systemctl is-active --quiet cri-docker.service 2>/dev/null; then
  echo "cri-docker.service is not active. Run: systemctl enable --now cri-docker.service"
  exit 1
fi

# Check cri-docker.socket is active
if ! systemctl is-active --quiet cri-docker.socket 2>/dev/null; then
  echo "cri-docker.socket is not active. Run: systemctl enable --now cri-docker.socket"
  exit 1
fi

# Check socket file exists
if ! test -S /var/run/cri-dockerd.sock; then
  echo "Socket /var/run/cri-dockerd.sock does not exist or is not a socket"
  exit 1
fi

echo "PASS"
exit 0
