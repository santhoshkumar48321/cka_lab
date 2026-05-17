## Tasks

1. Inspect PV `db-pv` and Deployment `postgres` in `db-ns`.
2. Create PVC `db-claim` that binds to storage class `db-storage`.
3. Modify Deployment `postgres` to mount the PVC at `/var/lib/postgresql/data`.

## Inspect existing resources

```bash
kubectl get pv db-pv
kubectl -n db-ns get deployment postgres -o yaml
```

## Skeleton (fill in the blanks)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ___________
  namespace: ___________
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: ___________
  storageClassName: ___________
```

```yaml
# In deployment postgres
volumeMounts:
- name: db-storage
  mountPath: ___________

volumes:
- name: db-storage
  persistentVolumeClaim:
    claimName: ___________
```

## Verify

```bash
kubectl -n db-ns get pvc db-claim
kubectl get pv db-pv -o jsonpath='{.status.phase}'
kubectl -n db-ns get deployment postgres -o jsonpath='{.spec.template.spec.volumes}'
```
