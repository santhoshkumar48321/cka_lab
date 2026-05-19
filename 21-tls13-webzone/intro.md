## Scenario
The legacy-server Deployment in the `web-zone` namespace uses an nginx ConfigMap named `secure-site-config`. It currently allows **only** TLSv1.3. A legacy compliance requirement now needs TLSv1.2 re-enabled.

## Goal
Update the nginx ConfigMap to allow **both** TLSv1.2 and TLSv1.3, then restart the Deployment to apply the change.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `legacy-server` | Deployment | `web-zone` | nginx, currently allows TLSv1.3 only |
| `secure-site-config` | ConfigMap | `web-zone` | ssl_protocols TLSv1.3 (must change) |
| `site-tls` | Secret | `web-zone` | TLS certificate for secure.demo.local |
| `legacy-server-svc` | Service | `web-zone` | ClusterIP, port 443 |

## Requirements

| Field | Value |
|---|---|
| Namespace | `web-zone` |
| Deployment | `legacy-server` |
| ConfigMap | `secure-site-config` |
| Service | `legacy-server-svc` |
| Allowed TLS | TLSv1.2 and TLSv1.3 |
| Required | TLSv1.3 must remain enabled |
