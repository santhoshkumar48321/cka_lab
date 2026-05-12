## Tasks

1. Verify the argo helm repo is available
2. Render the chart with CRDs ENABLED (default) and save to `/home/candidate/argo-cd-crds-enabled.yaml`
3. Render the chart with CRDs DISABLED and save to `/home/candidate/argo-cd-crds-disabled.yaml`

## Hints

```bash
# Check the pre-added repo
helm repo list
helm repo update

# Render with CRDs ENABLED (default behaviour):
helm template argocd argo/argo-cd \
  --version 8.0.17 \
  --namespace argocd \
  > /home/candidate/argo-cd-crds-enabled.yaml

# Render with CRDs DISABLED (fill in the flag):
helm template argocd argo/argo-cd \
  --version 8.0.17 \
  --namespace argocd-no-crds \
  --set crds.install=false \
  > /home/candidate/argo-cd-crds-disabled.yaml
```

> **Hint**: Use `--set crds.install=false` to disable CRD rendering. The chart URL is `https://argoproj.github.io/argo-helm`.

## Verify
```bash
ls -lh /home/candidate/argo-cd-crds-enabled.yaml
ls -lh /home/candidate/argo-cd-crds-disabled.yaml

# File 1 should contain CRDs:
grep -c 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-enabled.yaml

# File 2 should NOT contain CRDs:
grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-disabled.yaml && echo "FAIL: CRDs found" || echo "OK: No CRDs"
```
