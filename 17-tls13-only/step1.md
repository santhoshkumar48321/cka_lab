## Tasks

### Step 1 — Inspect the current TLS configuration
```bash
kubectl -n web-zone get configmap site-tls-config -o yaml
# Look for the ssl_protocols line — it currently allows TLSv1.2 TLSv1.3
```

### Step 2 — Edit the ConfigMap to allow TLSv1.3 ONLY
```bash
kubectl -n web-zone edit configmap site-tls-config
```
Change:
```
ssl_protocols TLSv1.2 TLSv1.3;
```
To:
```
ssl_protocols TLSv1.3;
```

### Step 3 — Restart the Deployment to pick up the ConfigMap change
```bash
kubectl -n web-zone rollout restart deployment secure-site
kubectl -n web-zone rollout status deployment secure-site
```

### Step 4 — Validate TLS enforcement
```bash
# Get the service ClusterIP
SVC_IP=$(kubectl -n web-zone get svc secure-site-svc -o jsonpath='{.spec.clusterIP}')
echo "$SVC_IP secure.demo.local" | tee -a /etc/hosts

# TLSv1.2 must FAIL:
curl --tls-max 1.2 https://secure.demo.local -k -v 2>&1 | grep -E 'error|SSL'

# TLSv1.3 must SUCCEED:
curl --tlsv1.3 https://secure.demo.local -k -o /dev/null -w "%{http_code}\n"
```

## Hints
```bash
kubectl -n web-zone get all
kubectl -n web-zone get configmap site-tls-config -o jsonpath='{.data.nginx\.conf}'
```

## Verify
```bash
kubectl -n web-zone get configmap site-tls-config -o jsonpath='{.data.nginx\.conf}' | grep ssl_protocols
```
