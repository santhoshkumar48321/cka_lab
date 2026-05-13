## Scenario
cert-manager is installed on the cluster, and a teammate needs quick reference notes for its CRDs. You need to list the available cert-manager CRDs and explain a specific field in the Certificate schema using kubectl.

## Goal
List all cert-manager CRDs and capture the kubectl explain output for Certificate.spec.subject.

## What exists in the cluster when you start

| Resource | Type | Notes |
|---|---|---|
| `certificates.cert-manager.io` | CRD | Certificate |
| `issuers.cert-manager.io` | CRD | Issuer |
| `clusterissuers.cert-manager.io` | CRD | ClusterIssuer |
| `certificaterequests.cert-manager.io` | CRD | CertificateRequest |

## Requirements

| Field | Value |
|---|---|
| CRD list file | `~/crds-list.txt` |
| Explain output file | `~/subject-explain.txt` |
| Explain target | `Certificate.spec.subject` |
