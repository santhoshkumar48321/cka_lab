## Tasks

1. List all Istio CRDs and save the output to `~/crds-list.yaml`:
```bash
kubectl get crd | grep istio.io > ~/crds-list.yaml
cat ~/crds-list.yaml
```

2. Extract documentation for `VirtualService.spec.hosts` using `kubectl explain` and save to `~/hosts-spec.yaml`:

```bash
# The short name for VirtualService is 'vs'. Try:
kubectl explain vs.spec.hosts > ~/hosts-spec.yaml

# If the short name isn't registered yet, use the full resource name:
kubectl explain virtualservices.networking.istio.io.spec.hosts > ~/hosts-spec.yaml
```

> **Tip**: `kubectl api-resources` and `kubectl explain` are allowed during the actual exam and are your best tools to discover API schemas without memorising them. Always try the short name first, then fall back to the full `resource.group.field` form.

## Why this matters for CKA
CRD discovery and `kubectl explain` usage are directly tested in the Cluster Architecture domain. You must know how to find resource fields without memorizing them.

## Verify
```bash
ls -lh ~/crds-list.yaml ~/hosts-spec.yaml
head -n 10 ~/crds-list.yaml
head -n 30 ~/hosts-spec.yaml
```
