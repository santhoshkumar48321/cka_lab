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

kubectl create namespace sound-zone --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: soundserver
  namespace: sound-zone
spec:
  replicas: 1
  selector:
    matchLabels:
      app: soundserver
  template:
    metadata:
      labels:
        app: soundserver
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 9090
YAML

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: soundserver-svc
  namespace: sound-zone
spec:
  type: ClusterIP
  selector:
    app: soundserver
  ports:
  - port: 9090
    targetPort: 9090
YAML

if ! grep -q 'mydemo.local' /etc/hosts 2>/dev/null; then
  echo "127.0.0.1 mydemo.local" >> /etc/hosts
fi

echo "Setup complete"
