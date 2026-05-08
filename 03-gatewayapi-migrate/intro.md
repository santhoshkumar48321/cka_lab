## Goal
Migrate the existing Ingress `api-ingress` to Gateway API resources.

## Context
The cluster already has Gateway API CRDs installed and `GatewayClass nginx-gateway` pre-created.
An existing `Ingress api-ingress` routes traffic for `api.demo.k8s.local` to `api-backend-svc:80`.

## Requirements
- Inspect existing Ingress `api-ingress` to understand its routing rules.
- Create a **Gateway** named `api-gateway` using GatewayClass `nginx-gateway` with an HTTP listener on port 80.
- Create an **HTTPRoute** named `api-route` that replicates the same routing rules.
- Both resources must be created in the `default` namespace.
