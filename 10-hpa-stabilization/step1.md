## Tasks

> **Important**: Use `autoscaling/v2` — only v2 supports the `behavior` field for stabilization windows. `autoscaling/v1` does not have this field.

### Step 1 — Check existing deployment
```bash
kubectl -n scaling get deployment nginx-deployment
kubectl -n scaling describe deployment nginx-deployment | grep -A3 Resources
```

### Step 2 — Create HPA `nginx-scaler` (fill in the blanks)
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ___________
  namespace: ___________
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ___________
  minReplicas: ___________
  maxReplicas: ___________
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: ___________
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
```

## Verify
```bash
kubectl -n scaling get hpa
kubectl -n scaling describe hpa nginx-scaler
kubectl -n scaling get hpa nginx-scaler -o yaml | grep -A5 'behavior:'
```
