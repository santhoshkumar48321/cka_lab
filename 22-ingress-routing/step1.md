## Tasks

1. Inspect the existing service in sound-zone:
```bash
kubectl -n sound-zone get svc soundserver-svc
kubectl -n sound-zone get pods --show-labels
```

2. Create the Ingress — fill in the blanks:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ___________
  namespace: ___________
spec:
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

## Hints
```bash
kubectl -n sound-zone get all
# The service soundserver-svc listens on port 9090
```

## Verify
```bash
kubectl -n sound-zone get ingress whisper
kubectl -n sound-zone describe ingress whisper
```
