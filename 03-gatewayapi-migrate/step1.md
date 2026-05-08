## Tasks

1. Inspect the existing Ingress:
```bash
kubectl get ingress api-ingress -o yaml
```

2. Create Gateway `api-gateway`:
```bash
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: api-gateway
spec:
  gatewayClassName: nginx-gateway
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    hostname: api.demo.k8s.local
EOF
```

3. Create HTTPRoute `api-route`:
```bash
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: api-route
spec:
  parentRefs:
  - name: api-gateway
  hostnames:
  - api.demo.k8s.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: api-backend-svc
      port: 80
EOF
```

## Verify
```bash
kubectl get gateway,httproute -A
kubectl describe gateway api-gateway
kubectl describe httproute api-route
```
