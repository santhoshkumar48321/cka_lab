## Tasks

### Step 1 — Inspect existing StorageClasses
```bash
kubectl get storageclass
kubectl get storageclass slow -o yaml
```

### Step 2 — Create `local-storage` StorageClass (fill in the blanks)
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ___________
  annotations:
    storageclass.kubernetes.io/is-default-class: "___________"
provisioner: ___________
volumeBindingMode: ___________
```

> **Tip**: The annotation value must be the string `"true"` (in quotes), not a boolean.

## Verify
```bash
kubectl get sc local-storage -o yaml
kubectl get sc local-storage -o jsonpath='{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}'; echo
kubectl get sc local-storage -o jsonpath='{.volumeBindingMode}'; echo
```
