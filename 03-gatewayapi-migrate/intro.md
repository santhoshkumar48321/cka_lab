## Goal
Migrate the existing Ingress `api-ingress` to Gateway API resources.

## Context
The cluster already has Gateway API CRDs installed and `GatewayClass nginx-gateway` pre-created.
An existing `Ingress api-ingress` routes traffic for `api.demo.k8s.local` to `web-svc:80`.

## Requirements
- Existing Deployment: `web`
- Existing Service: `web-svc`
- Existing Ingress: `api-ingress`
- Create Gateway `api-gateway` using GatewayClass `nginx-gateway` with an HTTP listener on port `80`.
- Create HTTPRoute `api-route` in namespace `default`.
- Route host `api.demo.k8s.local` path `/` to backend service `web-svc:80`.
