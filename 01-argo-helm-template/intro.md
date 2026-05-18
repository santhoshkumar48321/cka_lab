## Scenario
Your production cluster already has Argo CD CRDs installed. You need to generate two sets of Helm manifests: one with CRDs included (the reference copy) and one without CRDs (safe to apply to a cluster where CRDs already exist). You will then install Argo CD using the no-CRDs manifest. This is the standard GitOps pattern for managing Argo CD upgrades.

## Goal
Render the Argo CD Helm chart twice — once with CRDs enabled and once with CRDs disabled — save each to a file, then apply the no-CRDs manifest to the cluster.

## What exists when the scenario starts

| Resource | Type | Notes |
|---|---|---|
| `helm` | CLI tool | Pre-installed on the node |
| `argo` | Helm repo | Pre-added (`https://argoproj.github.io/argo-helm`) |
| `/home/candidate` | Directory | Output directory, pre-created |
| Argo CD CRDs | CRDs | Pre-installed in the cluster (simulate production) |

## Requirements

| Field | Value |
|---|---|
| Helm repo name | `argo` |
| Helm repo URL | `https://argoproj.github.io/argo-helm` |
| Chart | `argo/argo-cd` |
| Chart version | `8.0.17` |
| Output file 1 | `/home/candidate/argo-cd-crds-enabled.yaml` |
| Namespace for file 1 | `argocd` |
| File 1 constraint | Must CONTAIN `CustomResourceDefinition` resources |
| Output file 2 | `/home/candidate/argo-cd-crds-disabled.yaml` |
| Namespace for file 2 | `argocd-no-crds` |
| File 2 constraint | Must NOT contain any `CustomResourceDefinition` |
| Apply to cluster | File 2 only — apply to the `argocd-no-crds` namespace |
