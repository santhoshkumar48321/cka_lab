## Tasks

1. Inspect the existing Deployments in project-x namespace:
```bash
kubectl get deployments -n project-x
kubectl get pods -n project-x --show-labels
```

2. Create a default-deny NetworkPolicy for backend pods in project-x:
```yaml
# Skeleton — fill in the blanks
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
# Check existing pods and their labels
kubectl -n project-x get pods --show-labels
# Both frontend and backend are in the SAME namespace project-x
# Use podSelector (not namespaceSelector) for the from rule
```

## Verify
```bash
kubectl get networkpolicy -n project-x
kubectl describe networkpolicy -n project-x
```
