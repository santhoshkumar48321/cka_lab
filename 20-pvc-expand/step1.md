## Tasks

### Step 1 — Create PVC `site-content` (12Mi, csi-hostpath-sc, RWO)
```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: site-content
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: csi-hostpath-sc
  resources:
    requests:
      storage: 12Mi
EOF

# Confirm it binds immediately:
kubectl get pvc site-content
```

### Step 2 — Create Pod `nginx-site` mounting the PVC
```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx-site
spec:
  containers:
  - name: nginx
    image: nginx:1.27
    volumeMounts:
    - name: site-data
      mountPath: /usr/share/nginx/html
  volumes:
  - name: site-data
    persistentVolumeClaim:
      claimName: site-content
EOF
kubectl get pod nginx-site
```

### Step 3 — Expand PVC to 80Mi
```bash
kubectl patch pvc site-content -p '{"spec":{"resources":{"requests":{"storage":"80Mi"}}}}'
kubectl get pvc site-content
```

### Step 4 — Save YAML record after resize
```bash
mkdir -p /opt/CKA2026
kubectl get pvc site-content -o yaml > /opt/CKA2026/resize-record.yaml
grep storage /opt/CKA2026/resize-record.yaml
```

> **Exam tip**: In real clusters with a CSI driver that supports expansion, the filesystem is also expanded. The `status.capacity` field reflects the actual provisioned size. Here we use static provisioning — the spec update is what matters for verification.

## Verify
```bash
kubectl get pvc site-content
kubectl get pod nginx-site
grep -n 'storage:' /opt/CKA2026/resize-record.yaml
```
