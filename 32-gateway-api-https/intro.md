## Scenario
Your application is currently exposed via Ingress secure-ingress using HTTPS on api.zenhost.local. The company is migrating to Gateway API while keeping HTTPS access active. You must recreate the routing using Gateway and HTTPRoute.

## Goal
Create a Gateway named secure-gateway and an HTTPRoute named secure-route that replicate the HTTPS routing of the existing Ingress for host api.zenhost.local.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `secure-ingress` | Ingress | `default` | host: api.zenhost.local, TLS: api-tls, path / → api-backend-svc:443 |
| `api-backend-svc` | Service | `default` | ClusterIP port 443 |
| `api-tls` | Secret | `default` | TLS cert for api.zenhost.local |
| `nginx-gateway` | GatewayClass | cluster | controller: nginx.org/gateway-controller |

## Requirements

| Field | Value |
|---|---|
| Gateway name | `secure-gateway` |
| Gateway namespace | `default` |
| GatewayClass | `nginx-gateway` |
| HTTPS listener port | `443` |
| TLS secret reference | `api-tls` |
| HTTPRoute name | `secure-route` |
| Hostname | `api.zenhost.local` |
| Backend service | `api-backend-svc` |
| Backend port | `443` |
