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

# Find the target node (prefer worker, fall back to any)
worker_node=$(kubectl get nodes \
  -l '!node-role.kubernetes.io/control-plane,!node-role.kubernetes.io/master' \
  -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
if [ -z "$worker_node" ]; then
  worker_node=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
  # Single-node cluster: remove control-plane taint so pods can schedule
  kubectl taint nodes "$worker_node" node-role.kubernetes.io/control-plane:NoSchedule- \
    >/dev/null 2>&1 || true
  kubectl taint nodes "$worker_node" node-role.kubernetes.io/master:NoSchedule- \
    >/dev/null 2>&1 || true
fi

kubectl label node "$worker_node" disk=ssd --overwrite

echo "Labeled node $worker_node with disk=ssd"
echo "Setup complete"
