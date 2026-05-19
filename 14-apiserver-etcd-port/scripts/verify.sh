#!/usr/bin/env bash
set -euo pipefail

manifest="/etc/kubernetes/manifests/kube-apiserver.yaml"
etcd_manifest="/etc/kubernetes/manifests/etcd.yaml"

if ! test -s "$manifest"; then
  echo "kube-apiserver manifest not found at $manifest"
  exit 1
fi

if ! test -s "$etcd_manifest"; then
  echo "etcd manifest not found at $etcd_manifest"
  exit 1
fi

expected="$(grep -oP '(?<=--listen-client-urls=)[^[:space:],]+' "$etcd_manifest" | head -1 || true)"
if [ -z "$expected" ]; then
  expected="https://127.0.0.1:2379"
fi

current="$(grep -oP '(?<=--etcd-servers=)[^[:space:]]+' "$manifest" | head -1 || true)"
if [ -z "$current" ]; then
  echo "kube-apiserver --etcd-servers is missing"
  exit 1
fi

if ! test "$current" = "$expected"; then
  echo "kube-apiserver --etcd-servers must match etcd listen-client-urls: $expected (got: $current)"
  exit 1
fi

if grep -q -- '--etcd-servers=.*:2380' "$manifest"; then
  echo "kube-apiserver manifest still contains port 2380"
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
