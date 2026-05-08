#!/usr/bin/env bash
set -euo pipefail

wait_kube() {
  for i in $(seq 1 90); do
    if kubectl get ns >/dev/null 2>&1; then return 0; fi
    sleep 2
  done
  echo "Kubernetes API not ready" >&2; exit 1
}
wait_kube

# Find a node to taint (prefer worker, fall back to any node)
worker_node=$(kubectl get nodes \
  -l '!node-role.kubernetes.io/control-plane,!node-role.kubernetes.io/master' \
  -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
if [ -z "$worker_node" ]; then
  worker_node=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
fi

kubectl taint nodes "$worker_node" Env=Production:NoSchedule --overwrite

echo "Tainted node: $worker_node"
echo "Setup complete"
