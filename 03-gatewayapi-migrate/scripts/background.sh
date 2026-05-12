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

# Install Gateway API CRDs (v1.2.0 standard channel)
echo "Installing Gateway API CRDs..."
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml \
  || kubectl apply -f - <<'GWCRDS'
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: gatewayclasses.gateway.networking.k8s.io
spec:
  group: gateway.networking.k8s.io
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
  scope: Cluster
  names:
    plural: gatewayclasses
    singular: gatewayclass
    kind: GatewayClass
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: gateways.gateway.networking.k8s.io
spec:
  group: gateway.networking.k8s.io
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
  scope: Namespaced
  names:
    plural: gateways
    singular: gateway
    kind: Gateway
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: httproutes.gateway.networking.k8s.io
spec:
  group: gateway.networking.k8s.io
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
  scope: Namespaced
  names:
    plural: httproutes
    singular: httproute
    kind: HTTPRoute
GWCRDS

kubectl apply -f - <<'YAML'
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx-gateway
spec:
  controllerName: nginx.org/gateway-controller
YAML

# Generate TLS secret for api.zenhost.local
if ! command -v openssl >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y openssl
fi

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/api-tls.key -out /tmp/api-tls.crt \
  -subj "/CN=api.zenhost.local/O=demo" \
  -addext "subjectAltName=DNS:api.zenhost.local" 2>/dev/null

kubectl create secret tls api-tls --cert=/tmp/api-tls.crt --key=/tmp/api-tls.key \
  -n default --dry-run=client -o yaml | kubectl apply -f -

# Create backend resources
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-backend
  template:
    metadata:
      labels:
        app: api-backend
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
  name: api-backend-svc
spec:
  selector:
    app: api-backend
  ports:
  - port: 443
    targetPort: 80
YAML

kubectl apply -f - <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: secure-ingress
spec:
  tls:
  - hosts:
    - api.zenhost.local
    secretName: api-tls
  rules:
  - host: api.zenhost.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-backend-svc
            port:
              number: 443
YAML

echo "Setup complete"
