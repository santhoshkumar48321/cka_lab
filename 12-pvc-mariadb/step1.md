## Tasks

> **Important**: Create the PVC **before** applying the deployment. If the deployment is applied first, the pod will fail to schedule because the PVC doesn't exist yet.

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
# Apply and confirm it binds:
kubectl -n database get pvc database-storage
```

### Step 2 — Edit `/opt/database.yaml`

The template already has the volumeMount and volumes sections as commented-out blocks. Uncomment them and remove the TODO comments. The completed file should look like:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: database
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: mariadb:10.6
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: rootpassword
        - name: MYSQL_DATABASE
          value: appdb
        volumeMounts:
        - name: data
          mountPath: /var/lib/mysql
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: database-storage
```

### Step 3 — Apply the completed manifest
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
