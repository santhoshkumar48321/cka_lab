## Tasks

1. Add the official Argo CD Helm repository with name `argo`
2. Update the repo cache
3. Render the chart with CRDs ENABLED (default) and save to file 1
4. Render the chart with CRDs DISABLED and save to file 2
5. Apply `/home/candidate/argo-cd-crds-disabled.yaml`
6. Wait for Argo CD pods to be Ready

## Inspect existing resources

```bash
kubectl get ns
kubectl get crd | grep argoproj.io | head
helm repo list
```

## Skeleton (fill in the blanks)

```bash
helm repo add argo ___________
helm repo update

helm template argocd argo/argo-cd \
  --version ___________ \
  --namespace argocd \
  > /home/candidate/argo-cd-crds-enabled.yaml

helm template argocd argo/argo-cd \
  --version ___________ \
  --namespace argocd \
  --___________ \
  > /home/candidate/argo-cd-crds-disabled.yaml

kubectl apply -f /home/candidate/argo-cd-crds-disabled.yaml
kubectl -n argocd wait --for=condition=Ready pod --all --timeout=120s
```

## Verify

```bash
ls -lh /home/candidate/argo-cd-crds-enabled.yaml
ls -lh /home/candidate/argo-cd-crds-disabled.yaml

grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-enabled.yaml
! grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-disabled.yaml

kubectl get namespace argocd
kubectl -n argocd get pods
```
