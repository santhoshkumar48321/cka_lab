## Tasks

1. Inspect the existing Ingress to confirm the backend service and host:
```bash
kubectl get ingress api-ingress -o yaml
```

2. Check the available GatewayClass:
```bash
kubectl get gatewayclass
```

3. Create Gateway `api-gateway` — fill in the blanks:
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: ___________
  namespace: ___________
spec:
  gatewayClassName: ___________
  listeners:
  - name: http
    protocol: HTTP
    port: ___________
    hostname: ___________
```

4. Create HTTPRoute `api-route` — fill in the blanks:
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: ___________
  namespace: ___________
spec:
  parentRefs:
  - name: ___________
  hostnames:
  - ___________
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: ___________
    backendRefs:
    - name: ___________
      port: ___________
```

## Verify
```bash
kubectl get gateway api-gateway -n default
kubectl get httproute api-route -n default -o yaml
```
