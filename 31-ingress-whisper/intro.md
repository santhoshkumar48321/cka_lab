## Scenario
A backend Service `mediaserver-svc` is running in namespace `media-zone`. You must expose it with an Ingress so requests to `http://media.demo.local/stream` route correctly.

## Goal
Create Ingress `stream-route` in `media-zone` for host `media.demo.local`, path `/stream`, backend `mediaserver-svc:8443`.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `mediaserver-svc` | Service | `media-zone` | ClusterIP, port 8443 |
| `mediaserver` | Deployment | `media-zone` | nginx:latest, containerPort 8443 |

## Requirements

| Field | Value |
|---|---|
| Namespace | `media-zone` |
| Ingress name | `stream-route` |
| Host | `media.demo.local` |
| Path | `/stream` |
| Backend service | `mediaserver-svc` |
| Backend port | `8443` |
