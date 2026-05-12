## Scenario
You are managing a Deployment named ui-app in the dev-lab namespace. The nginx container currently has no explicit port spec. You need to update the Deployment to expose port 80/TCP and then create a NodePort Service.

## Goal
Modify the ui-app Deployment to add a named container port (http/80), then create NodePort Service ui-service that exposes it.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `ui-app` | Deployment | `dev-lab` | nginx:latest, 2 replicas, NO containerPort defined |

## Requirements

| Field | Value |
|---|---|
| Deployment | `ui-app` |
| Namespace | `dev-lab` |
| Container port | `80/TCP` |
| Port name | `http` |
| Service name | `ui-service` |
| Service type | `NodePort` |
| Service port | `80` |
| NodePort range | `30000–32767` (auto-assigned) |

> **Important**: Do NOT recreate the Deployment — only modify it. The container currently has NO port spec defined — you must add it.
