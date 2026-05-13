## Tasks

### Step 0 — Calculate fair-share values (exam technique)
```bash
kubectl describe node | grep -A5 'Allocatable'
# Divide CPU and memory by 3 replicas for requests.
# Set limits to 2x requests as a safe default.
# This lab uses example values 200m/128Mi (limits 400m/256Mi).
```

### Step 1 — Inspect current state
```bash
kubectl describe deployment webapp-deployment
kubectl get deployment webapp-deployment -o jsonpath='{.spec.template.spec.initContainers[0].resources}'; echo
kubectl get deployment webapp-deployment -o jsonpath='{.spec.template.spec.containers[0].resources}'; echo
```

### Step 2 — Scale down to 1 replica (easier to edit)
```bash
kubectl scale deploy webapp-deployment --replicas=1
```

### Step 3 — Edit the deployment

Use `kubectl edit deploy webapp-deployment` and add the resource block to **both** `initContainers` and `containers`:

```yaml
# Add under each container spec (initContainers[0] AND containers[0]):
resources:
  requests:
    cpu: ___________     # target: 200m
    memory: ___________  # target: 128Mi
  limits:
    cpu: ___________     # target: 400m
    memory: ___________  # target: 256Mi
```

### Step 4 — Scale back to 3 replicas
```bash
kubectl scale deploy webapp-deployment --replicas=3
kubectl rollout status deploy/webapp-deployment
```

## Verify
```bash
kubectl get pods -l app=webapp
POD=$(kubectl get pods -l app=webapp -o name | head -1)
kubectl describe $POD | grep -A6 "Requests\|Limits"
```
