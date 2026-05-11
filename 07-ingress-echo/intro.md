## Scenario
Your team runs an `app` Deployment in the `demo-app` namespace. The deployment needs to be reachable from outside the cluster via an Ingress controller that is already configured on this cluster.

## Goal
Create a ClusterIP Service and an Ingress resource to expose the `app` Deployment externally on a specific host and path.

## What exists in the cluster when you start

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `app` | Deployment | `demo-app` | `nginx:latest`, containerPort 80 |

## Requirements
- Namespace: `demo-app`
- Service name: `app-service`, type `ClusterIP`, service port `8090`, targetPort `80`
- Ingress name: `app-ingress`
- Host: `demo.example.com`
- Path: `/api` (pathType: `Prefix`)
- Backend: `app-service:8090`
