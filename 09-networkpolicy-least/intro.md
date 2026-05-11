## Scenario
The `backend` namespace hosts an API service that is currently reachable from **all** pods in the cluster. A security review requires that only pods in the `frontend` namespace are allowed to reach it — all other traffic must be blocked.

## Goal
Apply a least-permissive NetworkPolicy strategy in the `backend` namespace: default-deny all ingress, then explicitly allow only `frontend` pods.

## What exists in the cluster when you start

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `frontend` | Namespace | — | label `kubernetes.io/metadata.name=frontend` |
| `backend` | Namespace | — | label `kubernetes.io/metadata.name=backend` |
| `frontend-app` | Deployment | `frontend` | pods labeled `app=frontend` |
| `backend-api` | Deployment | `backend` | pods labeled `app=backend`, port 80 |

## Requirements
- Create a **default-deny** NetworkPolicy in namespace `backend` blocking all ingress
- Create an **allow** NetworkPolicy in namespace `backend` permitting ingress from the `frontend` namespace to port 80
