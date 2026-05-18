## Scenario
`webapp-deployment` runs 3 replicas but pods are being OOMKilled because there are no resource boundaries. The cluster has limited capacity and you need to set equal requests and limits on every container so the scheduler can place pods fairly.

## Goal
Set CPU and memory requests/limits on **both** the `initContainer` and the main container in `webapp-deployment`, then restore it to 3 replicas.

## Step 0 — Calculate fair-share values (exam technique)
1. Check allocatable resources on a node:
   `kubectl describe node | grep -A5 'Allocatable'`
2. Divide CPU and memory by the number of replicas (3) to pick request values.
3. Set limits to **2x** the requests as a safe default.

> **Note**: This lab uses fixed example values (200m / 128Mi) so you can focus on the workflow. In the real exam, you must calculate the values from the cluster.

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
