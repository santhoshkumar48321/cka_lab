## Tasks

### Step 1 — Inspect the existing Deployment
```bash
kubectl -n demo-app get deployment app -o wide
kubectl -n demo-app describe deployment app
```

### Step 2 — Create Service `app-service`

Use `kubectl expose` or write a YAML manifest:
```bash
# Hint: fill in the port and target-port values
kubectl -n demo-app expose deployment app \
  --name=app-service \
  --port=_____ \
  --target-port=_____ \
  --type=_____
```

### Step 3 — Create Ingress `app-ingress` (fill in the blanks)
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ___________
  namespace: ___________
spec:
  ingressClassName: ___________
  rules:
  - host: ___________
    http:
      paths:
      - path: ___________
        pathType: ___________
        backend:
          service:
            name: ___________
            port:
              number: ___________
```

## Verify
```bash
kubectl -n demo-app get ing,svc
kubectl -n demo-app describe ingress app-ingress
kubectl -n demo-app get service app-service -o jsonpath='{.spec.ports[0]}'
```
