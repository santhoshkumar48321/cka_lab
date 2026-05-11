## Scenario
`webapp-deployment` runs 3 replicas but pods are being OOMKilled because there are no resource boundaries. The cluster has limited capacity and you need to set equal requests and limits on every container so the scheduler can place pods fairly.

## Goal
Set CPU and memory requests/limits on **both** the `initContainer` and the main container in `webapp-deployment`, then restore it to 3 replicas.

## What exists in the cluster when you start

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `webapp-deployment` | Deployment | `default` | 3 replicas, 1 initContainer (`init-setup`), 1 container (`webapp`) — **no** resource requests or limits |

## Requirements
- Deployment: `webapp-deployment`
- Set the following values on **both** `initContainers[0]` and `containers[0]`:
  - `requests.cpu: 200m`
  - `requests.memory: 128Mi`
  - `limits.cpu: 400m`
  - `limits.memory: 256Mi`
- Final replica count: **3**
