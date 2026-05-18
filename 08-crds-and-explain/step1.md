## Tasks

1. List all cert-manager CRDs and save the output to `~/crds-list.txt`:
```bash
kubectl get crd | grep cert-manager.io > ~/crds-list.txt
cat ~/crds-list.txt
```

2. Extract documentation for `Certificate.spec.subject` and save to `~/subject-explain.txt`:
```bash
kubectl explain certificate.spec.subject > ~/subject-explain.txt

# Fallback if the short name isn't registered:
kubectl explain certificates.cert-manager.io.spec.subject > ~/subject-explain.txt
```

> **Hint**: If a short name isn't registered, always use the full `resource.group.field` format.

## Verify
```bash
ls -lh ~/crds-list.txt ~/subject-explain.txt
head -n 5 ~/crds-list.txt
head -n 20 ~/subject-explain.txt
```
