## Tasks

1. Inspect the existing `myapp` Deployment to understand its current volume setup
2. Edit Deployment `myapp` to add a sidecar container `logshipper`
3. Ensure the shared volume `data` is mounted at `/var/log` in **both** containers
4. Do NOT modify or delete the existing `myapp` container

## Inspect existing resources
```bash
kubectl get deployment myapp -o yaml
kubectl describe deployment myapp
```

## Sidecar spec skeleton (fill in the blanks)
```yaml
# Add this under spec.template.spec.containers (alongside the existing myapp container):
- name: ___________          # name of the sidecar
  image: ___________         # alpine image
  command: ["tail", "-f", "___________"]  # tail the log file at /var/log/logs.txt
  volumeMounts:
  - name: ___________        # same volume name as the main container: data
    mountPath: ___________   # path to mount: /var/log
```

## Hints
```bash
# Check the existing containers and volumes
kubectl get deployment myapp -o jsonpath='{.spec.template.spec.containers[*].name}'
kubectl get deployment myapp -o jsonpath='{.spec.template.spec.volumes[*].name}'

# After editing, check both containers have the mount:
kubectl get deployment myapp \
  -o jsonpath='{range .spec.template.spec.containers[*]}{.name}:{range .volumeMounts[*]}{.mountPath}{" "}{end}{"\n"}{end}'
```

## Verify
```bash
kubectl rollout status deploy/myapp
kubectl get pod -l app=myapp -o jsonpath='{.items[0].spec.containers[*].name}'; echo
kubectl logs deploy/myapp -c logshipper --tail=5
```
