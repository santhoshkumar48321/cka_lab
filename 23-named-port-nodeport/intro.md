## Scenario
A frontend Deployment needs to be updated with an explicit named port spec before a NodePort Service can reference it by name. This allows the Service to target the container port symbolically rather than by number.

## Goal
Reconfigure an existing Deployment to expose a named port, then create a NodePort Service using that named port.

## Requirements
- Deployment name: `ui-frontend`
- Namespace: `portal`

1. Update the Deployment and add port spec:
   - name: `http`
   - containerPort: `80`
   - protocol: `TCP`

2. Create a Service:
   - name: `ui-frontend-svc`
   - expose target port by name: `http`
   - type: `NodePort`
