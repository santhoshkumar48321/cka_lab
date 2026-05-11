#!/usr/bin/env bash
set -euo pipefail

wait_kube() {
  for i in $(seq 1 60); do
    if kubectl get ns >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  echo "Kubernetes API not ready after 60 seconds" >&2
  exit 1
}
wait_kube

kubectl create namespace database --dry-run=client -o yaml | kubectl apply -f -

# ── Install local-path-provisioner (enables dynamic PVC binding) ──
if ! kubectl get storageclass standard >/dev/null 2>&1; then
  echo "Installing local-path-provisioner..."
  kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

  # Wait for provisioner pod
  for i in $(seq 1 60); do
    if kubectl get pods -n local-path-storage 2>/dev/null | grep -q 'Running'; then
      break
    fi
    sleep 3
  done

  # Create a standard StorageClass alias
  kubectl apply -f - <<'YAML'
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
YAML
fi

mkdir -p /opt

# ── Template for the user to edit ──
cat > /opt/database.yaml << 'EOF'
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
        # TODO: add volumeMount here
        # volumeMounts:
        # - name: data
        #   mountPath: /var/lib/mysql
      # TODO: add volumes here
      # volumes:
      # - name: data
      #   persistentVolumeClaim:
      #     claimName: database-storage
EOF

echo "Setup complete"
