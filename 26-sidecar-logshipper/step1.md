## Tasks

1. Inspect the existing `data-processor` Deployment to understand its current volume setup
2. Edit Deployment `data-processor` to add a sidecar container `logshipper`
3. Ensure the shared volume `output-data` is mounted at `/data` in **both** containers
4. Do NOT modify or delete the existing `processor` container

## Inspect existing resources
```bash
kubectl get deployment data-processor -o yaml
kubectl describe deployment data-processor
```

## Sidecar spec skeleton (fill in the blanks)
```yaml
# Add this under spec.template.spec.containers (alongside the existing processor container):
- name: ___________          # name of the sidecar: logshipper
  image: ___________         # alpine:latest
  command: ["tail", "-f", "___________"]  # /data/output.log
  volumeMounts:
  - name: ___________        # output-data
    mountPath: ___________   # /data
```

## Hints
```bash
# Check the existing containers and volumes
kubectl get deployment data-processor -o jsonpath='{.spec.template.spec.containers[*].name}'
kubectl get deployment data-processor -o jsonpath='{.spec.template.spec.volumes[*].name}'
```

## Verify
```bash
kubectl rollout status deploy/data-processor
kubectl get pod -l app=data-processor -o jsonpath='{.items[0].spec.containers[*].name}'; echo
kubectl logs deploy/data-processor -c logshipper --tail=5
```
