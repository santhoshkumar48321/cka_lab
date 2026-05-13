## Tasks

### Step 0 — Identify the highest PriorityClass value
```bash
kubectl get priorityclass
# Note the highest value — your target is that value minus 1.
```

### Step 1 — Create PriorityClass `critical-priority`
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

### Step 2 — Patch `logger-app` to use the new PriorityClass
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
