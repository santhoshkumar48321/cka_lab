## Scenario
You need to create a Pod and expose it through a NodePort Service.

## Goal
Create Pod `web-pod` (`nginx:latest`) with label `app=web-pod` in namespace `nodeport-lab`, then create NodePort Service `web-svc` exposing port 80.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `nodeport-lab` | Namespace | cluster | Exists, no workload yet |

## Requirements

| Field | Value |
|---|---|
| Pod | `web-pod` |
| Namespace | `nodeport-lab` |
| Image | `nginx:latest` |
| Pod label | `app=web-pod` |
| Service | `web-svc` |
| Service type | `NodePort` |
| Service port | `80` |
| Selector | `app=web-pod` |
| NodePort range | `30000–32767` |
