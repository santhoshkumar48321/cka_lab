## Scenario
Your team needs to add Docker as an alternative container runtime on this node using `cri-dockerd` — a shim that makes Docker Engine compatible with the Kubernetes CRI interface.

## Goal
Install and enable `cri-dockerd`, then apply the required kernel networking parameters.

## What exists in the node when you start

| Resource | Notes |
|---|---|
| `docker.io` | Already installed |
| `~/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb` | Downloaded and ready to install |

## Requirements
- Install the `.deb` package from `~/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb`
- Enable **and** start the `cri-docker` service (both so it survives reboots)
- Apply and persist these sysctl values:
  - `net.bridge.bridge-nf-call-iptables = 1`
  - `net.ipv6.conf.all.forwarding = 1`
  - `net.ipv4.ip_forward = 1`
  - `net.netfilter.nf_conntrack_max = 262144`
