## Scenario
Your cluster has Argo CD CRDs pre-installed. You need to generate application manifests using Helm without re-installing those CRDs — otherwise `kubectl apply` would fail with a "CRD already exists" error.

## Goal
Render the Argo CD Helm chart to a local YAML file, skipping CRD generation.

## What exists in the cluster when you start

| Resource | Type | Notes |
|---|---|---|
| `helm` | CLI tool | Pre-installed on the node |

## Requirements
- Add Helm repo name: `argocd-repo`
- Render chart version: **7.6.8**
- Namespace: `gitops`
- Save output to: `/home/candidate/argocd-manifest.yaml`
- Output must **not** contain any `CustomResourceDefinition` resource
- Do **not** apply/install to the cluster
