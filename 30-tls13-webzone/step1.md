## Tasks

### Step 1 — Inspect the current TLS configuration
```bash
kubectl -n web-zone get configmap secure-site-config -o yaml
# Look for the ssl_protocols line — it currently allows TLSv1.3 only
```

### Step 2 — Edit the ConfigMap to allow TLSv1.2 + TLSv1.3
```bash
kubectl -n web-zone edit configmap secure-site-config
```
Change:
```
ssl_protocols TLSv1.3;
```
To:
```
ssl_protocols TLSv1.2 TLSv1.3;
```

### Step 3 — Restart the Deployment to pick up the ConfigMap change
```bash
kubectl -n web-zone rollout restart deployment legacy-server
kubectl -n web-zone rollout status deployment legacy-server
```

## Hints
```bash
kubectl -n web-zone get all
kubectl -n web-zone get configmap secure-site-config -o jsonpath='{.data.nginx\.conf}'
```

## Verify
```bash
kubectl -n web-zone get configmap secure-site-config -o jsonpath='{.data.nginx\.conf}' | grep ssl_protocols
```
