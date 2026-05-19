## Scenario
The `data-processor` Deployment writes results to `/data/output.log` inside its container. There is no way to stream these logs with `kubectl logs`. You must add a sidecar that tails the file to stdout.

## Goal
Add a `logshipper` sidecar container to the `data-processor` Deployment so its stdout streams `/data/output.log` — without modifying or deleting the original processor container.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `data-processor` | Deployment | `default` | 1 replica, `busybox:1.36`, writes to `/data/output.log` via shared emptyDir `output-data` |

## Requirements

| Field | Value |
|---|---|
| Deployment | `data-processor` |
| Main container | `processor` |
| Sidecar name | `logshipper` |
| Sidecar image | `alpine:latest` |
| Command | `tail -f /data/output.log` |
| Shared volume name | `output-data` |
| Volume mount path | `/data` (both containers) |
| Constraint | Do NOT modify or delete the `processor` container |
| Constraint | `logshipper` must be a sidecar, not an initContainer |
