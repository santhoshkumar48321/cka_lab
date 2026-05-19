## Tasks

1. Inspect existing Service `mediaserver-svc` in `media-zone`.
2. Create Ingress `stream-route` with host/path routing to service port 8443.
3. Configure TLS using the existing secret `media-tls`.

## Inspect existing resources

```bash
kubectl -n media-zone get svc mediaserver-svc
kubectl -n media-zone get pods --show-labels
```

## Skeleton (fill in the blanks)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ___________
  namespace: ___________
spec:
  tls:
  - hosts:
    - ___________
    secretName: ___________
  rules:
  - host: ___________
    http:
      paths:
      - path: ___________
        pathType: Prefix
        backend:
          service:
            name: ___________
            port:
              number: ___________
```

## Verify

```bash
kubectl -n media-zone get ingress stream-route
kubectl -n media-zone describe ingress stream-route
```
