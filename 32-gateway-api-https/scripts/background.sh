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

echo "Installing Gateway API CRDs..."
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml \
  || true

kubectl apply -f - <<'YAML'
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx-class
spec:
  controllerName: nginx.org/gateway-controller
YAML

if ! command -v openssl >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y openssl
fi

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/web-tls.key -out /tmp/web-tls.crt \
  -subj "/CN=web.cluster.local/O=demo" \
  -addext "subjectAltName=DNS:web.cluster.local" 2>/dev/null

kubectl create secret tls web-tls --cert=/tmp/web-tls.crt --key=/tmp/web-tls.key \
  -n default --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-backend
  template:
    metadata:
      labels:
        app: web-backend
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-backend-svc
spec:
  selector:
    app: web-backend
  ports:
  - port: 443
    targetPort: 80
YAML

kubectl apply -f - <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  tls:
  - hosts:
    - web.cluster.local
    secretName: web-tls
  rules:
  - host: web.cluster.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-backend-svc
            port:
              number: 443
YAML

echo "Setup complete"
