## Tasks

### Step 0 — Identify the highest PriorityClass value
```bash
kubectl get priorityclass
expr 1000000 - 1   # = 999999
```

### Step 1 — Create PriorityClass `critical-priority`
```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: critical-priority
value: 999999
globalDefault: false
description: "One less than high-priority"
```

### Step 2 — Patch `logger-app` to use the new PriorityClass
```bash
kubectl patch deployment logger-app -n production \
  --type=merge \
  -p '{"spec":{"template":{"spec":{"priorityClassName":"critical-priority"}}}}'
```

## Verify
```bash
kubectl get priorityclass critical-priority
kubectl get deploy logger-app -n production -o jsonpath='{.spec.template.spec.priorityClassName}'; echo
```
