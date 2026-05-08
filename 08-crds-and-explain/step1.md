## Tasks

1. List all Istio CRDs and save the output to `~/crds-list.yaml`:
```bash
kubectl get crd | grep istio.io > ~/crds-list.yaml
cat ~/crds-list.yaml
```

2. Extract documentation for `VirtualService.spec.hosts` using `kubectl explain` and save to `~/hosts-spec.yaml`:
```bash
kubectl explain virtualservice.spec.hosts > ~/hosts-spec.yaml
# If the short name isn't registered yet, use the full resource name:
# kubectl explain virtualservices.networking.istio.io.spec.hosts > ~/hosts-spec.yaml
cat ~/hosts-spec.yaml
```

## Why this matters for CKA
`kubectl api-resources` and `kubectl explain` are allowed during the actual exam and are your best tools to discover API schemas without memorizing them.

## Verify
```bash
ls -lh ~/crds-list.yaml ~/hosts-spec.yaml
head -n 10 ~/crds-list.yaml
head -n 30 ~/hosts-spec.yaml
```
