#!/usr/bin/env bash
set -euo pipefail

if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon is not running. Run: service docker start && docker info"
  exit 1
fi

if [ ! -s /root/kubeadm-init.log ]; then
  echo "File /root/kubeadm-init.log is missing or empty"
  exit 1
fi

if ! grep -q "kubeadm join" /root/kubeadm-init.log; then
  echo "kubeadm init output must include a kubeadm join command"
  exit 1
fi

if ! grep -Eq "cri-dockerd|unix:///var/run/cri-dockerd.sock" /root/kubeadm-init.log; then
  echo "kubeadm init output must reference the cri-dockerd socket"
  exit 1
fi

echo "PASS"
exit 0
