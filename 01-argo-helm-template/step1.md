## Tasks

1. Add the official Argo CD Helm repository with name `argo`
2. Update the repo cache
3. Render the chart with CRDs ENABLED (default) and save to file 1
4. Render the chart with CRDs DISABLED and save to file 2
5. Create the `argocd-no-crds` namespace
6. Install Argo CD by applying the no-CRDs manifest to the cluster

---

## Hints

```bash
# Task 1-2: Add repo and update cache
helm repo add argo <HELM_REPO_URL>
helm repo update

# Task 3: Render with CRDs ENABLED (default behaviour)
helm template argocd argo/argo-cd \
  --version <VERSION> \
  --namespace argocd \
  > /home/candidate/argo-cd-crds-enabled.yaml

# Task 4: Render with CRDs DISABLED (fill in the flag)
helm template argocd argo/argo-cd \
  --version <VERSION> \
  --namespace argocd-no-crds \
  --<FLAG_TO_SKIP_CRDS> \
  > /home/candidate/argo-cd-crds-disabled.yaml

# Task 5: Create the target namespace.
# Task 6: Install Argo CD by applying the no-CRDs manifest.
# The cluster already has Argo CD CRDs installed — applying the no-CRDs
# file is the safe, idempotent way to deploy without CRD conflicts.
kubectl create namespace ___________
kubectl apply -f /home/candidate/argo-cd-crds-disabled.yaml
```

> **Hint — which flag?** Use `--set crds.install=false` **or** `--skip-crds`.
> The chart repo URL is `https://argoproj.github.io/argo-helm`.
> After applying, watch pods with `kubectl -n argocd-no-crds get pods -w`.

## Verify

```bash
# Files exist and have content
ls -lh /home/candidate/argo-cd-crds-enabled.yaml
ls -lh /home/candidate/argo-cd-crds-disabled.yaml

# File 1 must contain CRDs
grep -c 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-enabled.yaml

# File 2 must NOT contain CRDs
grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-disabled.yaml \
  && echo "❌ CRDs found" || echo "✅ No CRDs"

# Namespace and deployment must exist after Task 6
kubectl get namespace argocd-no-crds
kubectl -n argocd-no-crds get deploy
```
