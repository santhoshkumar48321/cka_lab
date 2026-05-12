## Scenario
The web-app Deployment in the frontend namespace is running but has no persistent storage. A retained PersistentVolume already exists with 500Mi capacity. You need to claim it with a PVC and attach it to the existing Deployment.

## Goal
Create PVC web-pvc in the frontend namespace, bind it to the existing PV web-pv, and modify the web-app Deployment to mount it at /usr/share/nginx/html.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `web-app` | Deployment | `frontend` | nginx:latest, 1 replica, NO persistent storage |
| `web-pv` | PersistentVolume | cluster | 500Mi, Retain, Available, storageClass: manual |

## Requirements

| Field | Value |
|---|---|
| PVC name | `web-pvc` |
| Namespace | `frontend` |
| Storage request | `250Mi` |
| StorageClass | `manual` |
| Access mode | `ReadWriteOnce` |
| Mount path | `/usr/share/nginx/html` |
| Deployment | `web-app` (modify — do NOT recreate) |

> **Important**: Modify the existing web-app Deployment — do not delete and recreate it.
