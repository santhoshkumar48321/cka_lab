## Tasks

1. Create Pod `web-pod` in `nodeport-lab` with image `nginx:latest` and label `app=web-pod`.
2. Create NodePort Service `web-svc` selecting `app=web-pod` on port `80`.

## Create the Pod
```bash
kubectl run web-pod \
  -n nodeport-lab \
  --image=nginx:latest \
  --labels=app=web-pod
```

## Create the NodePort Service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: nodeport-lab
spec:
  type: NodePort
  selector:
    app: web-pod
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
```

## Verify
```bash
kubectl -n nodeport-lab get pod web-pod
kubectl -n nodeport-lab get svc web-svc
kubectl -n nodeport-lab describe svc web-svc
```
