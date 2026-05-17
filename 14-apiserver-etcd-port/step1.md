## Tasks

1. Open `/etc/kubernetes/manifests/kube-apiserver.yaml`.
2. Find the `--etcd-servers=` argument and change `:2380` to `:2379`.
3. Save the manifest.

The API server restarts automatically when the manifest is saved.
Wait ~30 seconds then test with: `kubectl get nodes`.

## Inspect existing resources

```bash
grep -- '--etcd-servers=' /etc/kubernetes/manifests/kube-apiserver.yaml
```

## Skeleton (fill in the blanks)

```yaml
- --etcd-servers=https://127.0.0.1:___________
```

## Verify

```bash
grep -- '--etcd-servers=' /etc/kubernetes/manifests/kube-apiserver.yaml
kubectl get nodes
```
