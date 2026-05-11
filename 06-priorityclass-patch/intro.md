## Scenario
The `production` namespace runs a `logger-app` Deployment. Ops needs a new PriorityClass that slots in just below the existing highest-priority class so critical workloads are scheduled first without displacing truly high-priority pods.

## Goal
Create PriorityClass `critical-priority` with value `999` (one below the existing maximum of `1000`), then patch `logger-app` to use it.

## What exists in the cluster when you start

| Resource | Type | Notes |
|---|---|---|
| `high-priority` | PriorityClass | value: **1000** |
| `low-priority` | PriorityClass | value: **100** |
| `logger-app` | Deployment | namespace: `production`, no priorityClassName set |

## Requirements
- New PriorityClass name: `critical-priority`
- Value: `999` (highest existing is `1000`, so `1000 - 1 = 999`)
- Patch Deployment `logger-app` in namespace `production` to use `priorityClassName: critical-priority`
