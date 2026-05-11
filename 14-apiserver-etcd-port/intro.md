## Scenario
After migration, kube-apiserver points to etcd peer port 2380 instead of client port 2379.

## Goal
Fix kube-apiserver etcd endpoint to use port 2379.

## Requirements
- File to edit: `/etc/kubernetes/manifests/kube-apiserver.yaml`
- Update `--etcd-servers=` endpoint to use port `2379`
- Ensure no `--etcd-servers=` endpoint remains on port `2380`
- API server must recover and return healthy `kubectl get nodes`
