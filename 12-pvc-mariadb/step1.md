## Tasks

> ⚠️ **Create the PVC BEFORE applying the Deployment. If the Deployment is applied first, the pod cannot schedule.**

### Step 1 — Create PVC `database-storage` (fill in the blanks)
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ___________
  namespace: ___________
spec:
  accessModes:
  - ___________
  storageClassName: ___________
  resources:
    requests:
      storage: ___________
```

```bash
kubectl -n database get pvc database-storage
```

### Step 2 — Edit `/opt/database.yaml`

Uncomment and complete the `volumeMounts` and `volumes` sections so the pod mounts the PVC at `/var/lib/mysql`.

### Step 3 — Apply the manifest
```bash
kubectl apply -f /opt/database.yaml
kubectl -n database rollout status deployment/mariadb
```

## Verify
```bash
kubectl -n database get pvc database-storage
kubectl -n database describe pvc database-storage
kubectl -n database get pods
```
