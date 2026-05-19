## Scenario
The `nginx-deployment` in the `scaling` namespace scales down too aggressively after load spikes, causing poor user experience. You need to configure an HPA with a stabilization window so scale-down happens gradually.

## Goal
Create an HPA named `nginx-scaler` targeting `nginx-deployment` with a 30-second scale-down stabilization window.

## What exists in the cluster when you start

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `nginx-deployment` | Deployment | `scaling` | 2 replicas, `nginx:latest`, `cpu request: 100m` |

## Requirements
- Namespace: `scaling`
- HPA name: `nginx-scaler`
- Target deployment: `nginx-deployment`
- CPU utilization target: `60%`
- `minReplicas`: `2`
- `maxReplicas`: `6`
- Scale-down `stabilizationWindowSeconds`: `30`
