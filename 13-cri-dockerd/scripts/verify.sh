#!/usr/bin/env bash
set -euo pipefail

# Check binary exists in either common install location
if ! command -v cri-dockerd >/dev/null 2>&1 && \
   ! test -x /usr/bin/cri-dockerd && \
   ! test -x /usr/local/bin/cri-dockerd; then
  echo "cri-dockerd binary not found (checked PATH, /usr/bin, /usr/local/bin)"
  exit 1
fi

# Check service is active
if ! systemctl is-active --quiet cri-docker 2>/dev/null; then
  echo "cri-docker service is not active. Run: systemctl enable --now cri-docker"
  exit 1
fi

# Check required sysctl values
check_sysctl() {
  local key="$1"
  local expected="$2"
  local actual
  actual=$(sysctl -n "$key" 2>/dev/null || echo "")
  if ! test "$actual" = "$expected"; then
    echo "sysctl $key must be $expected, got: '${actual:-not set}'"
    return 1
  fi
}

check_sysctl net.bridge.bridge-nf-call-iptables 1
check_sysctl net.ipv4.ip_forward 1

echo "PASS"
exit 0
