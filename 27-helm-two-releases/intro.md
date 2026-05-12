## Scenario
Your cluster has Argo CD CRDs pre-installed. You need to generate two sets of Helm manifests: one with CRDs (the full install) and one without CRDs (for clusters where they are already present). This is a common GitOps pipeline pattern.

## Goal
Render the Argo CD Helm chart twice — once with CRDs enabled and once with CRDs disabled — saving each output to a separate file in /home/candidate.

## What exists when the scenario starts

| Resource | Type | Notes |
|---|---|---|
| `helm` | CLI tool | Pre-installed on the node |
| `argo` | Helm repo | Pre-added at https://argoproj.github.io/argo-helm |
| `/home/candidate` | Directory | Output directory, pre-created |

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
| Do NOT | Apply/install to the cluster |
