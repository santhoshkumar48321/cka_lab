## Scenario
You manage a Deployment named `web-api` in namespace `api-ns`. The container has no explicit port definition yet, and the app must be exposed through a NodePort Service.

## Goal
Create ConfigMap `web-api-config` with key `config.json`, mount it at `/etc/api` in Deployment `web-api`, expose named container port `api` on `8080`, then create NodePort Service `web-api-svc`.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `web-api` | Deployment | `api-ns` | nginx:latest, 2 replicas, no containerPort set |

## Requirements

| Field | Value |
|---|---|
| Deployment | `web-api` |
| Namespace | `api-ns` |
| ConfigMap | `web-api-config` |
| ConfigMap key | `config.json` |
| Mount path | `/etc/api` |
| Container port | `8080/TCP` |
| Port name | `api` |
| Service name | `web-api-svc` |
| Service type | `NodePort` |
| Service port | `8080` |
