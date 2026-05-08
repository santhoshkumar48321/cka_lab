## Tasks

### Step 1 — Inspect the current TLS configuration
```bash
kubectl -n web get configmap nginx-tls-config -o yaml
# Look for the ssl_protocols line — it currently allows TLSv1.2 TLSv1.3
```

### Step 2 — Edit the ConfigMap to allow TLSv1.3 ONLY
```bash
kubectl -n web edit configmap nginx-tls-config
```
Change:
```
ssl_protocols TLSv1.2 TLSv1.3;
```
To:
```
ssl_protocols TLSv1.3;
```

### Step 3 — Restart the pod to pick up the ConfigMap change
```bash
kubectl -n web rollout restart deployment web-server
kubectl -n web rollout status deployment web-server
```

### Step 4 — Validate TLS enforcement
```bash
# Add host entry
SVC_IP=$(kubectl -n web get svc web-service -o jsonpath='{.spec.clusterIP}')
echo "$SVC_IP secure.demo.local" | tee -a /etc/hosts

# TLSv1.2 must FAIL:
curl --tls-max 1.2 https://secure.demo.local -k -v 2>&1 | grep -E 'error|SSL'

# TLSv1.3 must SUCCEED:
curl --tlsv1.3 https://secure.demo.local -k -o /dev/null -w "%{http_code}\n"
```

## Verify
```bash
kubectl -n web get configmap nginx-tls-config -o jsonpath='{.data.nginx\.conf}' | grep ssl_protocols
```
