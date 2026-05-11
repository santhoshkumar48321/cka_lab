## Tasks
1. Add the official Argo CD Helm repository with name `argocd-repo`
2. Update the repo cache
3. Render the Helm chart with CRDs **excluded** and save to `/home/candidate/argocd-manifest.yaml`

## Hints

```bash
# Add the repo (fill in the correct URL)
helm repo add argocd-repo <HELM_REPO_URL>
helm repo update

# Render the chart (fill in the blanks):
helm template argocd argocd-repo/argo-cd \
  --version <VERSION> \
  --namespace <NAMESPACE> \
  --<FLAG_TO_SKIP_CRDS> \
  > /home/candidate/argocd-manifest.yaml
```

> **Hint**: The flag that prevents CRD output is `--skip-crds`. The chart URL is `https://argoproj.github.io/argo-helm`.

## Verify
```bash
ls -lh /home/candidate/argocd-manifest.yaml
grep -n '^kind: CustomResourceDefinition' /home/candidate/argocd-manifest.yaml && echo "❌ CRDs found" || echo "✅ No CRDs"
```
