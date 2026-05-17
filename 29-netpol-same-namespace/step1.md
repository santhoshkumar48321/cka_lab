## Tasks

1. Inspect existing Deployments in namespace `data-tier`.
2. Create NetworkPolicy `allow-db-from-gateway` with pod selectors and TCP port 5432.

## Inspect existing resources

```bash
kubectl get deployments -n data-tier
kubectl get pods -n data-tier --show-labels
```

## Skeleton (fill in the blanks)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ___________
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

## Verify

```bash
kubectl get networkpolicy -n data-tier
kubectl describe networkpolicy -n data-tier
```
