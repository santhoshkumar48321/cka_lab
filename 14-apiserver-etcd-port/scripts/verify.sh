#!/usr/bin/env bash
set -euo pipefail

manifest="/etc/kubernetes/manifests/kube-apiserver.yaml"

if ! test -s "$manifest"; then
  echo "kube-apiserver manifest not found at $manifest"
  exit 1
fi

if ! grep -q -- '--etcd-servers=.*:2379' "$manifest"; then
  echo "kube-apiserver --etcd-servers must use port 2379 (not 2380)"
  exit 1
fi

if grep -q -- '--etcd-servers=.*:2380' "$manifest"; then
  echo "kube-apiserver manifest still contains port 2380 – fix to 2379"
  exit 1
fi

echo "Waiting for API server to become healthy..."
healthy=0
for i in $(seq 1 45); do
  if kubectl --request-timeout=15s get nodes >/dev/null 2>&1; then
    healthy=1
    break
  fi
  sleep 2
done

if [ "$healthy" -ne 1 ]; then
  echo "API server did not recover in time. Check kubelet: journalctl -u kubelet | tail -30"
  exit 1
fi

echo "PASS"
exit 0
