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

mkdir -p /opt/CKA2026/payment-api

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: payment-api
spec:
  containers:
  - name: payment-api
    image: busybox:1.36
    command: ["/bin/sh", "-c"]
    args:
    - |
      while true; do
        echo "INFO processing payment request id=1234"
        echo "error file-not-found: receipt_1234.pdf"
        echo "INFO payment completed successfully"
        echo "error file-not-found: invoice_5678.pdf"
        echo "INFO request completed"
        sleep 2
      done
YAML

# Wait for pod to be Running so logs are available when user starts
echo "Waiting for payment-api pod to be Running..."
for i in $(seq 1 60); do
  phase=$(kubectl get pod payment-api -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
  if [ "$phase" = "Running" ]; then
    echo "Pod is Running"
    break
  fi
  sleep 3
done

echo "Setup complete"
