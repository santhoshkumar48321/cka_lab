## Tasks

### Step 1 — Create ClusterRole deployment-manager
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ___________
rules:
- apiGroups: ["___________"]
  resources: ["___________"]
  verbs: [___________]
```

### Step 2 — Create RoleBinding in staging namespace
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ___________
  namespace: ___________
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ___________
subjects:
- kind: ServiceAccount
  name: ___________
  namespace: ___________
```

### Step 3 — Verify permissions
```bash
# Should return yes:
kubectl auth can-i create deployments \
  --as=system:serviceaccount:ci-cd:deploy-bot -n staging

# Should return no:
kubectl auth can-i create deployments \
  --as=system:serviceaccount:ci-cd:deploy-bot -n production
```

## Hints
```bash
kubectl get clusterrole deployment-manager -o yaml
kubectl get rolebinding deploy-bot-staging -n staging -o yaml
```

## Verify
```bash
kubectl get clusterrole deployment-manager
kubectl get rolebinding deploy-bot-staging -n staging
kubectl auth can-i create deployments --as=system:serviceaccount:ci-cd:deploy-bot -n staging
kubectl auth can-i create deployments --as=system:serviceaccount:ci-cd:deploy-bot -n production
```
