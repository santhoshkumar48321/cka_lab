## Tasks

Create NetworkPolicies to allow ONLY `frontend-app` → `backend-api` traffic on port 80, blocking everything else.

### Step 1 — Check namespace labels
```bash
kubectl get namespace frontend backend --show-labels
```

### Step 2 — Default-deny all ingress to `backend` namespace (fill in the blanks)
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: ___________
spec:
  podSelector: {}        # selects ALL pods in the namespace
  policyTypes:
  - ___________
```

### Step 3 — Allow ingress from `frontend` namespace only (fill in the blanks)
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-frontend
  namespace: ___________
spec:
  podSelector:
    matchLabels:
      app: ___________
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: ___________
    ports:
    - protocol: TCP
      port: ___________
```

> **Tip**: NetworkPolicies are **additive**. A default-deny policy + an allow policy = least-permissive. Without the default-deny, traffic from other pods is still allowed.

## Verify
```bash
kubectl get netpol -n backend
kubectl -n backend describe netpol allow-from-frontend
kubectl -n backend describe netpol default-deny-ingress
```
