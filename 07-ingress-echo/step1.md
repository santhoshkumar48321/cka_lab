## Tasks
1. Create Service `app-service` (type **ClusterIP**) on service port **8090** targeting the nginx app pods on port **80**:
```bash
kubectl -n demo-app expose deployment app \
  --name=app-service \
  --port=8090 \
  --target-port=80 \
  --type=ClusterIP
```

2. Create Ingress `app-ingress` in namespace `demo-app`:
   - host: `demo.example.com`
   - path: `/api` (pathType: Prefix)
   - backend: `app-service:8090`

```bash
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: demo-app
spec:
  rules:
  - host: demo.example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 8090
EOF
```

## Verify
```bash
kubectl -n demo-app get ing,svc
kubectl -n demo-app describe ingress app-ingress
kubectl -n demo-app get service app-service -o jsonpath='{.spec.ports[0]}'
```
