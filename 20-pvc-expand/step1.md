## Tasks

### Step 1 — Inspect existing resources
```bash
kubectl get pv web-pv
kubectl -n frontend get deployment web-app -o yaml
```

### Step 2 — Create PVC web-pvc in the frontend namespace
```yaml
# Skeleton — fill in the blanks
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ___________
  namespace: ___________
spec:
  accessModes:
  - ___________
  resources:
    requests:
      storage: ___________
  storageClassName: ___________
```

### Step 3 — Verify PVC is Bound
```bash
kubectl -n frontend get pvc web-pvc
# STATUS should show Bound
```

### Step 4 — Edit Deployment web-app to add the volume mount (DO NOT recreate)
```bash
kubectl -n frontend edit deployment web-app
```
Add a volume and volumeMount:
```yaml
# Under spec.template.spec.volumes (at spec level, not inside containers):
volumes:
- name: web-storage
  persistentVolumeClaim:
    claimName: web-pvc

# Under spec.template.spec.containers[0].volumeMounts:
volumeMounts:
- name: web-storage
  mountPath: /usr/share/nginx/html
```

## Hints
```bash
kubectl get pv web-pv -o yaml
kubectl -n frontend get pvc
```

## Verify
```bash
kubectl -n frontend get pvc web-pvc
kubectl get pv web-pv -o jsonpath='{.status.phase}'
kubectl -n frontend get deployment web-app -o jsonpath='{.spec.template.spec.volumes}'
```
