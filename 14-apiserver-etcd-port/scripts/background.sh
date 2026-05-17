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

manifest="/etc/kubernetes/manifests/kube-apiserver.yaml"
if [ ! -f "$manifest" ]; then
  echo "API server manifest not found at $manifest" >&2
  exit 1
fi

cp -a "$manifest" "${manifest}.bak.$(date +%s)"

if grep -q ':2379' "$manifest"; then
  sed -i '/--etcd-servers=/s/:2379/:2380/g' "$manifest"
fi

echo "Setup complete"
