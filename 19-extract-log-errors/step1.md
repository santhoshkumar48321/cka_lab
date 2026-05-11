## Tasks
1. Get logs from Pod `log-pod`
2. Filter for lines containing `error file-not-found`
3. Save matching lines to `/opt/CKA2026/log-pod/errors.log`

## Suggested approach
```bash
mkdir -p /opt/CKA2026/log-pod
kubectl logs log-pod | grep "error file-not-found" > /opt/CKA2026/log-pod/errors.log
```

## Verify
```bash
test -f /opt/CKA2026/log-pod/errors.log && echo "File exists"
wc -l /opt/CKA2026/log-pod/errors.log
head -n 5 /opt/CKA2026/log-pod/errors.log
```
