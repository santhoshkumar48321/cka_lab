## Scenario
You manage a web server Deployment called secure-site in the web-zone namespace. Its nginx configuration is stored in ConfigMap site-tls-config. A security audit requires that TLS 1.2 be completely disabled — only TLS 1.3 may be accepted.

## Goal
Update the nginx ConfigMap to restrict TLS to version 1.3 only, then restart the Deployment to apply the change.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `secure-site` | Deployment | `web-zone` | nginx, currently allows TLSv1.2 + TLSv1.3 |
| `site-tls-config` | ConfigMap | `web-zone` | ssl_protocols TLSv1.2 TLSv1.3 (must change) |
| `site-tls` | Secret | `web-zone` | TLS certificate for secure.demo.local |
| `secure-site-svc` | Service | `web-zone` | ClusterIP, port 443 |

## Requirements

| Field | Value |
|---|---|
| Namespace | `web-zone` |
| Deployment | `secure-site` |
| ConfigMap | `site-tls-config` |
| Service | `secure-site-svc` |
| Allowed TLS | TLSv1.3 only |
| Forbidden | TLSv1.2 must be removed from ssl_protocols |
| The container currently has NO port spec defined — you must add it |
