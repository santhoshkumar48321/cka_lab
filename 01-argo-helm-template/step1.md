## Tasks

1. Add the official Argo CD Helm repository with name `argo`
2. Update the repo cache
3. Render the chart with CRDs ENABLED (default) and save to file 1
4. Render the chart with CRDs DISABLED and save to file 2
5. Create namespace `argocd-no-crds`
6. Apply the no-CRDs manifest to the cluster in `argocd-no-crds`
7. Confirm at least one Deployment exists in `argocd-no-crds`

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
  --namespace argocd-no-crds \
  --___________ \
  > /home/candidate/argo-cd-crds-disabled.yaml

kubectl create namespace argocd-no-crds
kubectl apply -f /home/candidate/argo-cd-crds-disabled.yaml -n argocd-no-crds
```

## Verify

```bash
ls -lh /home/candidate/argo-cd-crds-enabled.yaml
ls -lh /home/candidate/argo-cd-crds-disabled.yaml

grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-enabled.yaml
! grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-disabled.yaml

kubectl get namespace argocd-no-crds
kubectl -n argocd-no-crds get deploy
```
