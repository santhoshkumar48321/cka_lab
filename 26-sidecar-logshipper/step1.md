## Tasks

1. Inspect the existing `myapp` Deployment to understand its current volume setup
2. Edit Deployment `myapp` to add a sidecar container `logshipper`
3. Ensure the shared volume `data` is mounted at `/opt` in **both** containers
4. Do NOT modify or delete the existing `myapp` container

## Inspect existing resources
```bash
kubectl get deployment myapp -o yaml
kubectl describe deployment myapp
```

## Sidecar spec skeleton (fill in the blanks)
```yaml
# Add this under spec.template.spec.containers (alongside the existing myapp container):
- name: ___________          # name of the sidecar: logshipper
  image: ___________         # alpine:latest
  command: ["tail", "-f", "___________"]  # /opt/logs.txt
  volumeMounts:
  - name: ___________        # data
    mountPath: ___________   # /opt
```

## Hints
```bash
# Check the existing containers and volumes
kubectl get deployment myapp -o jsonpath='{.spec.template.spec.containers[*].name}'
kubectl get deployment myapp -o jsonpath='{.spec.template.spec.volumes[*].name}'
```

## Verify
```bash
kubectl rollout status deploy/myapp
kubectl get pod -l app=myapp -o jsonpath='{.items[0].spec.containers[*].name}'; echo
kubectl logs deploy/myapp -c logshipper --tail=5
```
