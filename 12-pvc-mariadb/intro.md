## Scenario
The database team needs persistent storage for MariaDB. A deployment template has been pre-created at `/opt/database.yaml` with placeholders — you need to create the PersistentVolumeClaim and fill in the template so MariaDB starts with durable storage.

## Goal
Create a PVC, complete the `/opt/database.yaml` template with the PVC and volumeMount, and apply it so MariaDB runs successfully.

## What exists in the cluster when you start

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `database` | Namespace | — | pre-created |
| `standard` | StorageClass | cluster-scoped | `rancher.io/local-path`, default |
| `/opt/database.yaml` | File on node | — | incomplete template — `volumeMount` and `volumes` sections are commented out |

## Requirements
- PVC name: `database-storage`, namespace: `database`
- AccessMode: `ReadWriteOnce`, size: `500Mi`, StorageClass: `standard`
- Update `/opt/database.yaml` to uncomment and use the PVC
- Mount path inside container: `/var/lib/mysql`
- Apply the completed manifest and verify the MariaDB pod is `Running`
