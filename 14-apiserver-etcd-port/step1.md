## Tasks

## Step 0 — Find the correct etcd endpoint BEFORE editing (exam technique)
```bash
grep 'listen-client-urls' /etc/kubernetes/manifests/etcd.yaml
# Note the exact https://IP:PORT — use this in kube-apiserver
```

1. Open `/etc/kubernetes/manifests/kube-apiserver.yaml`.
2. Find the `--etcd-servers=` argument and set it to the exact endpoint from etcd.yaml.
3. Save the manifest.

The API server restarts automatically when the manifest is saved.
Wait ~30 seconds then test with: `kubectl get nodes`.

## Inspect existing resources

```bash
grep -- '--etcd-servers=' /etc/kubernetes/manifests/kube-apiserver.yaml
```

## Verify

```bash
grep -- '--etcd-servers=' /etc/kubernetes/manifests/kube-apiserver.yaml
kubectl get nodes
```
