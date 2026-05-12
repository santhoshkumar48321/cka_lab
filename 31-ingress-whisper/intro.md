## Scenario
A backend service soundserver-svc is running in the sound-zone namespace. You need to create an Ingress so external requests to http://mydemo.local/whisper are forwarded to port 9090 of the service.

## Goal
Create an Ingress named whisper in the sound-zone namespace that routes host mydemo.local path /whisper to soundserver-svc on port 9090.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `soundserver-svc` | Service | `sound-zone` | ClusterIP, port 9090 |
| `soundserver` | Deployment | `sound-zone` | nginx:latest, containerPort 9090 |

## Requirements

| Field | Value |
|---|---|
| Ingress name | `whisper` |
| Namespace | `sound-zone` |
| Host | `mydemo.local` |
| Path | `/whisper` |
| Backend service | `soundserver-svc` |
| Backend port | `9090` |

Test: `curl -o /dev/null -s -w "%{http_code}\n" http://mydemo.local/whisper`
