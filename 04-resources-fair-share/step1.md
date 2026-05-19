## Tasks

## ⚠️ CRITICAL EXAM NOTE
Do NOT use a fixed percentage (10%, 20%). The exam warns against this.
Instead:
1. `kubectl describe node | grep -A6 Allocatable`
2. Divide each resource by 3 (number of replicas)
3. Round down slightly (e.g. 646m → 640m)
4. If pods don't schedule: `kubectl describe pod | grep -A5 Events`
   Reduce requests and retry until pods run

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
    cpu: ___________
    memory: ___________
  limits:
    cpu: ___________
    memory: ___________
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
