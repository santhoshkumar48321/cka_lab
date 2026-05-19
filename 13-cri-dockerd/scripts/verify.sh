#!/usr/bin/env bash
set -euo pipefail

if ! command -v cri-dockerd >/dev/null 2>&1 && \
   ! test -x /usr/bin/cri-dockerd && \
   ! test -x /usr/local/bin/cri-dockerd; then
  echo "cri-dockerd binary not found (checked PATH, /usr/bin, /usr/local/bin)"
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "FAIL: Docker daemon not running. Run: service docker start"
  exit 1
fi

ver=$(cri-dockerd --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
if [ -z "$ver" ]; then
  echo "Could not determine cri-dockerd version"
  exit 1
fi
major=$(echo "$ver" | awk -F. '{print $1}')
minor=$(echo "$ver" | awk -F. '{print $2}')
patch=$(echo "$ver" | awk -F. '{print $3}')
if [ "$major" -lt 0 ] || { [ "$minor" -lt 3 ] || { [ "$minor" -eq 3 ] && [ "$patch" -lt 15 ]; }; }; then
  echo "cri-dockerd version $ver uses Docker API 1.43. Install v0.3.15+ which supports API 1.44"
  exit 1
fi

if ! systemctl is-active --quiet cri-docker.service 2>/dev/null; then
  echo "cri-docker.service is not active. Run: systemctl enable --now cri-docker.service"
  exit 1
fi

if ! systemctl is-active --quiet cri-docker.socket 2>/dev/null; then
  echo "cri-docker.socket is not active. Run: systemctl enable --now cri-docker.socket"
  exit 1
fi

if ! test -S /var/run/cri-dockerd.sock; then
  echo "Socket /var/run/cri-dockerd.sock does not exist or is not a socket"
  exit 1
fi

for key in net.bridge.bridge-nf-call-iptables net.ipv4.ip_forward; do
  val=$(sysctl -n "$key" 2>/dev/null || echo "0")
  if [ "$val" != "1" ]; then
    echo "sysctl $key must be 1, got: $val. Run: sysctl -w $key=1"
    exit 1
  fi
done
ip6fwd=$(sysctl -n net.ipv6.conf.all.forwarding 2>/dev/null || echo "0")
if [ "$ip6fwd" != "1" ]; then
  echo "sysctl net.ipv6.conf.all.forwarding must be 1"
  exit 1
fi

echo "PASS"
exit 0
