## Scenario
A webapp container writes application logs to a file on disk (`/var/log/application.log`). You need to make those logs visible via `kubectl logs` without modifying the main container — a classic sidecar pattern.

## Goal
Add a `log-reader` sidecar container to the `webapp` Deployment so its stdout streams the log file.

## What exists in the cluster when you start

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `webapp` | Deployment | `default` | 1 replica, `busybox:1.36`, writes to `/var/log/application.log` via a shared emptyDir volume |

## Requirements
- Deployment: `webapp`
- Sidecar name: `log-reader`
- Sidecar image: `busybox:1.36`
- Command: `/bin/sh -c "tail -f /var/log/application.log"`
- The volume must be mounted at `/var/log` in **both** containers
