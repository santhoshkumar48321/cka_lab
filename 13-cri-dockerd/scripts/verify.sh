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

# Check required sysctl values
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
