## Tasks

1. Inspect the existing Ingress `api-ingress` and confirm the current backend service is `web-svc`.
2. Create Gateway `api-gateway` in namespace `default` using GatewayClass `nginx-gateway`.
3. Configure an HTTP listener on port `80` for hostname `api.demo.k8s.local`.
4. Create HTTPRoute `api-route` in namespace `default`.
5. Route path `/` to backend service `web-svc` on port `80`.

## Verify
```bash
kubectl get gateway api-gateway -n default
kubectl get httproute api-route -n default -o yaml
```
