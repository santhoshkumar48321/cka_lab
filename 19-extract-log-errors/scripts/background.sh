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

mkdir -p /opt/CKA2026/log-pod

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: log-pod
spec:
  volumes:
  - name: app-logs
    emptyDir: {}
  containers:
  - name: log-pod
    image: busybox:1.36
    command: ["/bin/sh", "-c"]
    args:
    - |
      while true; do
        echo "INFO processing payment request id=1234" | tee -a /var/log/app.log
        echo "error file-not-found: receipt_1234.pdf" | tee -a /var/log/app.log
        echo "INFO payment completed successfully" | tee -a /var/log/app.log
        echo "error file-not-found: invoice_5678.pdf" | tee -a /var/log/app.log
        echo "INFO request completed" | tee -a /var/log/app.log
        sleep 2
      done
    volumeMounts:
    - name: app-logs
      mountPath: /var/log
YAML

echo "Waiting for log-pod to be Running..."
for i in $(seq 1 60); do
  phase=$(kubectl get pod log-pod -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
  if [ "$phase" = "Running" ]; then
    echo "Pod is Running"
    break
  fi
  sleep 1
done

echo "Setup complete"
