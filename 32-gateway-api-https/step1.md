## Tasks

1. Inspect the existing Ingress:
```bash
kubectl get ingress secure-ingress -o yaml
```

2. Check the available GatewayClass:
```bash
kubectl get gatewayclass
```

3. Create Gateway `secure-gateway` — fill in the blanks:
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: ___________
  namespace: ___________
spec:
  gatewayClassName: ___________
  listeners:
  - name: https
    protocol: HTTPS
    port: ___________
    hostname: ___________
    tls:
      mode: Terminate
      certificateRefs:
      - name: ___________
        kind: Secret
```

4. Create HTTPRoute `secure-route` — fill in the blanks:
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
        value: /
    backendRefs:
    - name: ___________
      port: ___________
```

## Hints
```bash
kubectl get secret api-tls -o yaml
kubectl get gatewayclass nginx-gateway -o yaml
```

## Verify
```bash
kubectl get gateway secure-gateway -n default
kubectl get httproute secure-route -n default -o yaml
```
