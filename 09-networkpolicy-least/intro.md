## Scenario
In the project-x namespace, two Deployments run side by side. Currently all pods can communicate freely. Security requires that ONLY frontend pods may reach backend pods on port 8080. All other traffic — including from outside the namespace — must be blocked.

## Goal
Apply a least-permissive NetworkPolicy in the project-x namespace: deny all ingress to backend pods, then explicitly allow only frontend pods on port 8080.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `frontend` | Deployment | `project-x` | pods labeled `app=frontend` |
| `backend` | Deployment | `project-x` | pods labeled `app=backend`, port 8080 |

## Requirements

| Field | Value |
|---|---|
| Namespace | `project-x` |
| Policy selector | pods with label `app=backend` |
| Allow from | pods with label `app=frontend` (same namespace) |
| Allow port | TCP 8080 |
| Block | all other ingress |

> **Key constraint**: Both Deployments are in THE SAME namespace: `project-x`
