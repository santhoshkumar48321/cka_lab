## Tasks

1. Inspect the existing ui-app Deployment in dev-lab:
```bash
kubectl -n dev-lab get deployment ui-app -o yaml
# Note: the container has NO port spec currently
```

2. Edit the Deployment to add a named port (DO NOT recreate):
```bash
kubectl -n dev-lab edit deployment ui-app
```
Add under `spec.template.spec.containers[0].ports`:
```yaml
ports:
- name: http
  containerPort: 80
  protocol: TCP
```

3. Create the NodePort Service `ui-service`:
```yaml
# Skeleton — fill in the blanks
apiVersion: v1
kind: Service
metadata:
  name: ___________
  namespace: ___________
spec:
  type: ___________
  selector:
    app: ui-app
  ports:
  - name: http
    port: ___________
    targetPort: ___________
    protocol: TCP
```

## Hints
```bash
kubectl -n dev-lab get deployment ui-app -o jsonpath='{.spec.template.spec.containers[0].ports}'
kubectl -n dev-lab get pods --show-labels
```

## Verify
```bash
kubectl -n dev-lab get deployment ui-app -o jsonpath='{.spec.template.spec.containers[0].ports}'
kubectl -n dev-lab get service ui-service
kubectl -n dev-lab describe service ui-service
```
