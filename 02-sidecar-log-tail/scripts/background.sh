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
  name: myapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: busybox:1.36
        command: ["/bin/sh", "-c"]
        args:
        - |
          mkdir -p /var/log
          while true; do
            echo "$(date) app log entry" >> /var/log/logs.txt
            sleep 1
          done
        volumeMounts:
        - name: data
          mountPath: /var/log
      volumes:
      - name: data
        emptyDir: {}
YAML

echo "Setup complete"
