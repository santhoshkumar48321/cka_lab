## Scenario
⚠️ The API server will be unreachable when this scenario starts. This is expected.
⚠️ Do NOT use kubectl until you have fixed the manifest — kubectl will time out.

A kube-apiserver static pod manifest was changed to point at the wrong etcd port. You must repair the manifest so the API server can reconnect to etcd.

## Goal
Fix kube-apiserver `--etcd-servers` to use port `2379` and restore API server connectivity.

## What exists when the scenario starts
| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `/etc/kubernetes/manifests/kube-apiserver.yaml` | Static pod manifest | node | etcd endpoint intentionally set to `:2380` |
| `etcd` | Static pod | `kube-system` | Listening for client traffic on `:2379` |

## Requirements
| Field | Value |
|---|---|
| File to edit | `/etc/kubernetes/manifests/kube-apiserver.yaml` |
| Fix required | `--etcd-servers` must use `:2379` |
| Validation | `kubectl get nodes` succeeds |
