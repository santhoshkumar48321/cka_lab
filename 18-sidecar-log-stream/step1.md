## Tasks

> **Important**: Pods are immutable — you cannot add a container to a running Pod in-place.
> The correct approach is: **export → edit → delete old Pod → apply new Pod spec**.

### Step 1 — Export the existing Pod spec
```bash
kubectl get pod atlas-app -o yaml > /tmp/atlas-app.yaml
```

### Step 2 — Edit the exported YAML to add the sidecar

Open `/tmp/atlas-app.yaml` and add the `log-sidecar` container under `spec.containers`:
```yaml
- name: log-sidecar
  image: busybox:1.36
  command: ["/bin/sh", "-c"]
  args: ["tail -n+1 -F /var/log/atlas-app.log"]
  volumeMounts:
  - name: log-vol
    mountPath: /var/log
```

Make sure the existing `atlas-app` container also mounts the same volume `log-vol` at `/var/log`.

### Step 3 — Remove auto-generated metadata fields (required before re-apply)
```bash
# Remove resourceVersion, uid, creationTimestamp, status block
# Quickest: use kubectl replace or just remove the fields:
kubectl replace --force -f /tmp/atlas-app.yaml
```

## Verify

### Step 4 — Verify the sidecar is streaming
```bash
# List containers in the pod:
kubectl get pod atlas-app -o jsonpath='{.spec.containers[*].name}'; echo

# Check sidecar logs:
kubectl logs atlas-app -c log-sidecar --tail=30
```
