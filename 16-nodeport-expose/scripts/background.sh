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

kubectl create namespace dev-lab --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ui-app
  namespace: dev-lab
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ui-app
  template:
    metadata:
      labels:
        app: ui-app
    spec:
      containers:
      - name: nginx
        image: nginx:latest
YAML

echo "Setup complete"
