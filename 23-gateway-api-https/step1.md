## Tasks

1. Inspect existing Ingress and GatewayClass.
2. Create Gateway `web-gateway` with HTTPS listener on 443 and TLS secret `web-tls`.
3. Create HTTPRoute `web-route` to route host `web.cluster.local` to `web-backend-svc:443`.

## Inspect existing resources

```bash
kubectl get ingress web-ingress -o yaml
kubectl get gatewayclass
kubectl get secret web-tls -o yaml
```

## Skeleton (fill in the blanks)

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: ___________
  namespace: default
spec:
  gatewayClassName: ___________
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: ___________
    tls:
      mode: Terminate
      certificateRefs:
      - name: ___________
```

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: ___________
  namespace: default
spec:
  parentRefs:
  - name: ___________
  hostnames:
  - ___________
  rules:
  - backendRefs:
    - name: ___________
      port: 443
```

## Verify

```bash
kubectl get gateway web-gateway -n default
kubectl get httproute web-route -n default -o yaml
```
