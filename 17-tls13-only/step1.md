## Tasks

1. Inspect current TLS protocols in ConfigMap `site-tls-config`.
2. Edit the ConfigMap to REMOVE TLSv1.2 and keep only TLSv1.3.
3. Restart deployment `secure-site`.

## Inspect existing resources

```bash
kubectl -n web-zone get configmap site-tls-config -o yaml
```

## Skeleton (fill in the blanks)

```text
Change:
ssl_protocols TLSv1.2 TLSv1.3;

To:
ssl_protocols ___________;
```

```bash
kubectl -n web-zone rollout restart deployment secure-site
kubectl -n web-zone rollout status deployment secure-site
```

## Verify

```bash
kubectl -n web-zone get configmap site-tls-config -o jsonpath='{.data.nginx\.conf}' | grep ssl_protocols
```
