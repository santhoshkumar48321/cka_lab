## Tasks

1. Inspect the existing Deployments in project-x namespace:
```bash
kubectl get deployments -n project-x
kubectl get pods -n project-x --show-labels
```

2. Create a NetworkPolicy — fill in the blanks:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-allow-frontend
  namespace: ___________
spec:
  podSelector:
    matchLabels:
      app: ___________
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: ___________
    ports:
    - protocol: TCP
      port: ___________
```

## Hints
```bash
# Both frontend and backend are in the SAME namespace project-x
# Use podSelector (not namespaceSelector) for the from rule
kubectl -n project-x get pods --show-labels
```

## Verify
```bash
kubectl get networkpolicy -n project-x
kubectl describe networkpolicy -n project-x
```
