## Scenario
⚠️ The API server will be unreachable when this scenario starts. This is expected.
⚠️ Do NOT use kubectl until you have fixed the manifest — kubectl will time out.

A kube-apiserver static pod manifest was changed to point at the wrong etcd endpoint. You must repair the manifest so the API server can reconnect to etcd.

## Goal
Fix kube-apiserver `--etcd-servers` to use the exact endpoint from etcd and restore API server connectivity.

⚠️ Do NOT assume the port is 2379 — read it from:
`grep 'listen-client-urls' /etc/kubernetes/manifests/etcd.yaml`
The IP may also differ. Use the exact endpoint from etcd.yaml.

## What exists when the scenario starts
| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `/etc/kubernetes/manifests/kube-apiserver.yaml` | Static pod manifest | node | etcd endpoint intentionally set wrong |
| `etcd` | Static pod | `kube-system` | Endpoint must be read from etcd manifest |

## Requirements
| Field | Value |
|---|---|
| File to edit | `/etc/kubernetes/manifests/kube-apiserver.yaml` |
| Fix required | `--etcd-servers` must exactly match etcd listen-client-urls endpoint |
| Validation | `kubectl get nodes` succeeds |
