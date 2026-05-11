## Tasks

1. Inspect the existing `webapp` Deployment to understand its current volume setup
2. Edit Deployment `webapp` to add a sidecar container `log-reader`
3. Ensure the shared volume is mounted at `/var/log` in **both** containers

## Inspect existing resources
```bash
kubectl get deployment webapp -o yaml
kubectl describe deployment webapp
```

## Sidecar spec skeleton (fill in the blanks)
```yaml
# Add this under spec.template.spec.containers:
- name: ___________          # name of the sidecar
  image: ___________         # busybox image to use
  command: ["/bin/sh", "-c"]
  args: ["___________"]      # tail command for /var/log/application.log
  volumeMounts:
  - name: ___________        # same volume name as the main container
    mountPath: ___________   # path to mount
```

## Verify

```bash
kubectl rollout status deploy/webapp
kubectl get pod -l app=webapp -o jsonpath='{.items[0].spec.containers[*].name}'; echo
kubectl logs deploy/webapp -c log-reader --tail=20
```
