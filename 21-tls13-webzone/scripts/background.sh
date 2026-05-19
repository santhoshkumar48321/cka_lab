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

kubectl create namespace web-zone --dry-run=client -o yaml | kubectl apply -f -

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt \
  -subj "/CN=secure.demo.local/O=demo" \
  -addext "subjectAltName=DNS:secure.demo.local" 2>/dev/null

kubectl create secret tls site-tls --cert=/tmp/tls.crt --key=/tmp/tls.key \
  -n web-zone --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: ConfigMap
metadata:
  name: secure-site-config
  namespace: web-zone
data:
  nginx.conf: |
    events {}
    http {
      server {
        listen 443 ssl;
        ssl_certificate     /etc/nginx/certs/tls.crt;
        ssl_certificate_key /etc/nginx/certs/tls.key;
        ssl_protocols       TLSv1.3;
        location / { return 200 "ok\n"; }
      }
    }
YAML

kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: legacy-server
  namespace: web-zone
spec:
  replicas: 1
  selector:
    matchLabels:
      app: legacy-server
  template:
    metadata:
      labels:
        app: legacy-server
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 443
        volumeMounts:
        - name: config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        - name: certs
          mountPath: /etc/nginx/certs
      volumes:
      - name: config
        configMap:
          name: secure-site-config
      - name: certs
        secret:
          secretName: site-tls
YAML

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: legacy-server-svc
  namespace: web-zone
spec:
  type: ClusterIP
  selector:
    app: legacy-server
  ports:
  - port: 443
    targetPort: 443
YAML

echo "Setup complete"
