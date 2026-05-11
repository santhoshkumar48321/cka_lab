## Tasks

### Step 1 — Confirm existing PriorityClass values
```bash
kubectl get priorityclass -o wide
# The highest user-defined value is 1000 (high-priority).
# Your target: critical-priority with value 999.
```

### Step 2 — Create PriorityClass `critical-priority`
```yaml
# Fill in the blanks:
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: ___________
value: ___________
globalDefault: false
description: "___________"
```

### Step 3 — Patch `logger-app` to use the new PriorityClass
```bash
kubectl patch deployment logger-app -n production \
  --type=merge \
  -p '{"spec":{"template":{"spec":{"priorityClassName":"___________"}}}}'
```

## Verify
```bash
kubectl get priorityclass critical-priority
kubectl get deploy logger-app -n production -o jsonpath='{.spec.template.spec.priorityClassName}'; echo
```
