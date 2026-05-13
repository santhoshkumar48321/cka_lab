## Scenario
The cluster has a pre-created local PersistentVolume, but there is **no default StorageClass**. You must create the default StorageClass and then complete the full bind flow (StorageClass → PVC → Pod) so the claim binds successfully.

## Goal
Create a StorageClass named `local-storage`, then create a PVC and a Pod that uses it so the claim transitions from Pending to Bound.

## What exists in the cluster when you start

| Resource | Type | Notes |
|---|---|---|
| `slow` | StorageClass | `rancher.io/local-path`, **not** default |
| `pv-local` | PersistentVolume | hostPath 1Gi, available |

## Requirements
- StorageClass name: `local-storage`
- Provisioner: `rancher.io/local-path`
- `volumeBindingMode`: `WaitForFirstConsumer`
- Annotation `storageclass.kubernetes.io/is-default-class: "true"` (makes it the default)
- PVC name: `local-claim`, size `1Gi`, access mode `ReadWriteOnce`, no explicit `storageClassName`
- Pod name: `pvc-checker`, mount the PVC at `/data`
- Do **not** modify or delete the existing `slow` StorageClass
