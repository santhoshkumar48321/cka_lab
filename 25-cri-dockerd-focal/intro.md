## Scenario
cri-dockerd is already installed and running on this node. You must initialize the cluster with kubeadm **using the cri-dockerd socket**, and save the output for audit purposes.

## Goal
Run `kubeadm init` with the cri-dockerd socket and save the output to `/root/kubeadm-init.log`.

## What exists when the node starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `docker.io` | Package | node | Installed |
| `cri-dockerd` | Service | node | Installed and running |
| `/var/run/cri-dockerd.sock` | Socket | node | CRI socket path |

## Requirements

| Field | Value |
|---|---|
| Reset command | `kubeadm reset -f` |
| Init command | `kubeadm init` with `--cri-socket` |
| CRI socket | `unix:///var/run/cri-dockerd.sock` |
| Pod CIDR | `192.168.0.0/16` |
| Output log | `/root/kubeadm-init.log` |
