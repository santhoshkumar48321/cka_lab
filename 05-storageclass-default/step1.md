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

### Step 3 — Create PVC `local-claim` (no explicit storageClassName)
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ___________
spec:
  accessModes:
  - ___________
  resources:
    requests:
      storage: ___________
```

### Step 4 — Observe Pending (WaitForFirstConsumer)
```bash
kubectl get pvc local-claim
# Status stays Pending until a Pod uses the claim (expected with WFFC).
```

### Step 5 — Create a Pod that uses the PVC
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ___________
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh","-c","sleep 3600"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: ___________
```

### Step 6 — Confirm PVC is Bound and Pod is Running
```bash
kubectl get pvc local-claim
kubectl get pod pvc-checker
```

## Verify
```bash
kubectl get sc local-storage -o yaml
kubectl get sc local-storage -o jsonpath='{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}'; echo
kubectl get sc local-storage -o jsonpath='{.volumeBindingMode}'; echo
kubectl get pvc local-claim
kubectl get pod pvc-checker
```
