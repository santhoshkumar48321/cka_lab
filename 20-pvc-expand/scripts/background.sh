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

mkdir -p /opt/CKA2026
mkdir -p /mnt/site-content-pv

# ── StorageClass with allowVolumeExpansion=true (static provisioning) ──
kubectl apply -f - <<'YAML'
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: csi-hostpath-sc
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: Immediate
allowVolumeExpansion: true
reclaimPolicy: Retain
YAML

# ── Pre-created PersistentVolume (hostPath, 200Mi) ──
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: site-content-pv
spec:
  capacity:
    storage: 200Mi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: csi-hostpath-sc
  hostPath:
    path: /mnt/site-content-pv
    type: DirectoryOrCreate
YAML

echo "Setup complete"
