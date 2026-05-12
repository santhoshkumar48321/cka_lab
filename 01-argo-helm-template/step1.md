## Tasks

1. Add the official Argo CD Helm repository with name `argo`
2. Update the repo cache
3. Render the chart with CRDs ENABLED (default) and save to file 1
4. Render the chart with CRDs DISABLED and save to file 2

## Hints

```bash
# Add the repo (fill in the correct URL)
helm repo add argo <HELM_REPO_URL>
helm repo update

# Render with CRDs ENABLED (default behaviour):
helm template argocd argo/argo-cd \
  --version <VERSION> \
  --namespace argocd \
  > /home/candidate/argo-cd-crds-enabled.yaml

# Render with CRDs DISABLED (fill in the flag):
helm template argocd argo/argo-cd \
  --version <VERSION> \
  --namespace argocd-no-crds \
  --<FLAG_TO_SKIP_CRDS> \
  > /home/candidate/argo-cd-crds-disabled.yaml
```

> **Hint**: The flag to skip CRDs is `--set crds.install=false` or `--skip-crds`. The chart URL is `https://argoproj.github.io/argo-helm`.

## Verify
```bash
ls -lh /home/candidate/argo-cd-crds-enabled.yaml
ls -lh /home/candidate/argo-cd-crds-disabled.yaml

# File 1 should contain CRDs:
grep -c 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-enabled.yaml

# File 2 should NOT contain CRDs:
grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-disabled.yaml && echo "❌ CRDs found" || echo "✅ No CRDs"
```
