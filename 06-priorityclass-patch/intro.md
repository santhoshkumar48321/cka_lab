## Scenario
The `production` namespace runs a `logger-app` Deployment. Ops needs a new PriorityClass that slots in just below the existing highest-priority class so critical workloads are scheduled first without displacing truly high-priority pods.

## Goal
Create PriorityClass `critical-priority` with value `999999` (one less than the existing maximum: `expr 1000000 - 1 = 999999`), then patch `logger-app` to use it.

## What exists in the cluster when you start

| Resource | Type | Notes |
|---|---|---|
| `high-priority` | PriorityClass | value: **1000000** |
| `low-priority` | PriorityClass | value: **100** |
| `logger-app` | Deployment | namespace: `production`, no priorityClassName set |

## Requirements
- New PriorityClass name: `critical-priority`
- Value: `999999` (highest existing is `1000000`, so `1000000 - 1 = 999999`)
- Patch Deployment `logger-app` in namespace `production` to use `priorityClassName: critical-priority`
