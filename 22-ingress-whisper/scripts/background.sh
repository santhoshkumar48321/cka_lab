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

if ! command -v openssl >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y openssl
fi

kubectl create namespace media-zone --dry-run=client -o yaml | kubectl apply -f -

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/media-tls.key -out /tmp/media-tls.crt \
  -subj "/CN=media.demo.local/O=demo" \
  -addext "subjectAltName=DNS:media.demo.local" 2>/dev/null

kubectl create secret tls media-tls --cert=/tmp/media-tls.crt --key=/tmp/media-tls.key \
  -n media-zone --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mediaserver
  namespace: media-zone
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mediaserver
  template:
    metadata:
      labels:
        app: mediaserver
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 8443
YAML

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: mediaserver-svc
  namespace: media-zone
spec:
  type: ClusterIP
  selector:
    app: mediaserver
  ports:
  - port: 8443
    targetPort: 8443
YAML

if ! grep -q 'media.demo.local' /etc/hosts 2>/dev/null; then
  echo "127.0.0.1 media.demo.local" >> /etc/hosts
fi

echo "Setup complete"
