## Tasks

1. Inspect Deployment `web-api` in namespace `api-ns`.
2. Create ConfigMap `web-api-config` with key `config.json`.
3. Edit the Deployment to add named container port `api` on `8080` and mount the ConfigMap at `/etc/api`.
4. Create NodePort Service `web-api-svc` exposing port `8080`.

## Inspect existing resources

```bash
kubectl -n api-ns get deployment web-api -o yaml
kubectl -n api-ns get pods --show-labels
```

## ConfigMap skeleton
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ___________
  namespace: ___________
data:
  config.json: |
    {
      "env": "lab"
    }
```

## Skeleton (fill in the blanks)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: ___________
  namespace: ___________
spec:
  type: ___________
  selector:
    app: web-api
  ports:
  - name: ___________
    port: ___________
    targetPort: ___________
    protocol: TCP
```

## Verify

```bash
kubectl -n api-ns get configmap web-api-config
kubectl -n api-ns get deployment web-api -o jsonpath='{.spec.template.spec.containers[0].ports}'
kubectl -n api-ns get service web-api-svc
kubectl -n api-ns describe service web-api-svc
```
