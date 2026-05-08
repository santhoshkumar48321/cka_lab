## Tasks

Create NetworkPolicies to allow ONLY `frontend-app` → `backend-api` traffic on port 80, blocking everything else.

### Step 1 — Default-deny all ingress to `backend` namespace
```bash
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF
```

### Step 2 — Allow ingress from `frontend` namespace only
```bash
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-frontend
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: frontend
      podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 80
EOF
```

> **Tip**: NetworkPolicies are **additive**. A default-deny policy + an allow policy = least-permissive. Without the default-deny, traffic from other pods is still allowed.

## Verify
```bash
kubectl get netpol -n backend
kubectl -n backend describe netpol allow-from-frontend
kubectl -n backend describe netpol default-deny-ingress
```
