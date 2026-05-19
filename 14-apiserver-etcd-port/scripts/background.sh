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

CORRECT=$(grep -oP '(?<=--listen-client-urls=)[^\s,]+' \
  /etc/kubernetes/manifests/etcd.yaml | head -1 || echo "https://127.0.0.1:2379")
echo "$CORRECT" > /root/etcd-correct-endpoint.txt

cp -a "$manifest" "${manifest}.bak.$(date +%s)"

current=$(grep -oP '(?<=--etcd-servers=)[^\s]+' "$manifest" | head -1 || true)
if [ -n "$current" ] && [ "$current" = "$CORRECT" ]; then
  wrong="${CORRECT%:*}:2380"
  sed -i "s|--etcd-servers=$CORRECT|--etcd-servers=$wrong|g" "$manifest"
fi

echo "Setup complete"
