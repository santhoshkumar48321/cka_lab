## Scenario
Your team is migrating from the deprecated `networking.k8s.io/v1` Ingress API to the newer Gateway API. The cluster already has Gateway API CRDs and a `GatewayClass` installed. An existing `Ingress` routes traffic for `api.demo.k8s.local` to the `web-svc` backend.

## Goal
Create a `Gateway` and an `HTTPRoute` that replicate the same routing behaviour as the existing Ingress.

## What exists in the cluster when you start

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `api-ingress` | Ingress | `default` | Routes `api.demo.k8s.local /` → `web-svc:80` |
| `web` | Deployment | `default` | nginx:latest, port 80 |
| `web-svc` | Service | `default` | ClusterIP, port 80 |
| `nginx-gateway` | GatewayClass | cluster-scoped | controller: `nginx.org/gateway-controller` |

## Requirements
- Create Gateway `api-gateway` in namespace `default` using GatewayClass `nginx-gateway` with an HTTP listener on port `80`.
- Create HTTPRoute `api-route` in namespace `default`.
- Route host `api.demo.k8s.local` path `/` to backend service `web-svc:80`.
