## Scenario
Your application is currently exposed via Ingress using HTTPS on `web.cluster.local`. The team is migrating this routing to Gateway API.

## Goal
Create Gateway `web-gateway` and HTTPRoute `web-route` for host `web.cluster.local` using GatewayClass `nginx-class` and TLS secret `web-tls`.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `web-ingress` | Ingress | `default` | host `web.cluster.local`, TLS `web-tls`, backend `web-backend-svc:443` |
| `web-backend-svc` | Service | `default` | ClusterIP port 443 |
| `web-tls` | Secret | `default` | TLS cert for `web.cluster.local` |
| `nginx-class` | GatewayClass | cluster | controller `nginx.org/gateway-controller` |

## Requirements

| Field | Value |
|---|---|
| Gateway name | `web-gateway` |
| GatewayClass | `nginx-class` |
| HTTPRoute name | `web-route` |
| Hostname | `web.cluster.local` |
| Backend service | `web-backend-svc` |
| TLS secret | `web-tls` |
