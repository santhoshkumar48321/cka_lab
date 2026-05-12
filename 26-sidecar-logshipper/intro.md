## Scenario
The myapp Deployment writes logs to /opt/logs.txt inside its container. Currently there is no way to view these logs with kubectl logs. You need to add a sidecar that streams the file to stdout.

## Goal
Add a logshipper sidecar container to the myapp Deployment so its stdout streams /opt/logs.txt — without modifying or deleting the original myapp container.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `myapp` | Deployment | `default` | 1 replica, `busybox:1.36`, writes to `/opt/logs.txt` via shared emptyDir volume `data` |

## Requirements

| Field | Value |
|---|---|
| Deployment | `myapp` |
| Sidecar name | `logshipper` |
| Sidecar image | `alpine:latest` |
| Command | `tail -f /opt/logs.txt` |
| Shared volume name | `data` |
| Volume mount path | `/opt` (both containers) |
| Constraint | Do NOT modify or delete the `myapp` container |
| Constraint | `logshipper` must be a sidecar, not an initContainer |
