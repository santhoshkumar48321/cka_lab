## Scenario
In the project-x namespace, two Deployments run side by side. Currently all pods can communicate freely. Security requires that ONLY frontend pods may reach backend pods on port 8080. All other traffic — including from outside the namespace — must be blocked.

## Goal
Create a NetworkPolicy in project-x that allows only pods with label app=frontend to reach pods with label app=backend on TCP port 8080, blocking all other ingress.

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

> **Key constraint**: Both Deployments are in THE SAME namespace: `project-x`. Use `podSelector` (not `namespaceSelector`) for the from rule.
