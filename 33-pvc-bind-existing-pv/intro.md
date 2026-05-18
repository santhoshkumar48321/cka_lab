## Scenario
A `postgres` Deployment exists in namespace `db-ns` but currently has no persistent storage attached. A retained PV named `db-pv` already exists.

## Goal
Create PVC `db-claim` in `db-ns` to bind PV `db-pv`, then modify Deployment `postgres` to mount it at `/var/lib/postgresql/data`.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `postgres` | Deployment | `db-ns` | `postgres:14`, env `POSTGRES_PASSWORD=mysecretpassword`, no PVC mount |
| `db-pv` | PersistentVolume | cluster | hostPath `/mnt/db-data`, storageClass `db-storage`, Retain |

## Requirements

| Field | Value |
|---|---|
| PVC name | `db-claim` |
| Namespace | `db-ns` |
| StorageClass | `db-storage` |
| Deployment | `postgres` (modify, do not recreate) |
| Mount path | `/var/lib/postgresql/data` |
