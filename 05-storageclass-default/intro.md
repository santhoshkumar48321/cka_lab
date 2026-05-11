## Scenario
The cluster has no default StorageClass. Any PVC created without an explicit `storageClassName` stays in `Pending` indefinitely. You need to create and designate a default StorageClass so dynamic provisioning works out of the box.

## Goal
Create a StorageClass named `local-storage` and mark it as the cluster default.

## What exists in the cluster when you start

| Resource | Type | Notes |
|---|---|---|
| `slow` | StorageClass | `rancher.io/local-path`, **not** default |

## Requirements
- StorageClass name: `local-storage`
- Provisioner: `rancher.io/local-path`
- `volumeBindingMode`: `WaitForFirstConsumer`
- Annotation `storageclass.kubernetes.io/is-default-class: "true"` (makes it the default)
- Do **not** modify or delete the existing `slow` StorageClass
