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

kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: data-processor
spec:
  replicas: 1
  selector:
    matchLabels:
      app: data-processor
  template:
    metadata:
      labels:
        app: data-processor
    spec:
      containers:
      - name: processor
        image: busybox:1.36
        command: ["/bin/sh", "-c"]
        args:
        - |
          mkdir -p /data
          while true; do
            echo "\$(date) processing output" >> /data/output.log
            sleep 1
          done
        volumeMounts:
        - name: output-data
          mountPath: /data
      volumes:
      - name: output-data
        emptyDir: {}
YAML

echo "Setup complete"
