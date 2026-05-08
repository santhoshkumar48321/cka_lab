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

# ── Install Gateway API CRDs (v1.2.0 standard channel) ──
echo "Installing Gateway API CRDs..."
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml \
  || kubectl apply -f - <<'GWCRDS'
# Minimal inline fallback: GatewayClass + Gateway + HTTPRoute CRDs (skeleton)
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

# ── Create GatewayClass (referenced in intro as pre-existing) ──
kubectl apply -f - <<'YAML'
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx-gateway
spec:
  controllerName: nginx.org/gateway-controller
YAML

# ── Backend Service ──
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
      - name: api-backend
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: api-backend-svc
spec:
  type: ClusterIP
  selector:
    app: api-backend
  ports:
  - port: 80
    targetPort: 80
YAML

# ── Existing Ingress for the user to migrate ──
kubectl apply -f - <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
spec:
  rules:
  - host: api.demo.k8s.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-backend-svc
            port:
              number: 80
YAML

echo "Setup complete"
