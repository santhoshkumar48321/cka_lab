## Scenario
Your team needs to configure Docker Engine as a CRI-compatible runtime using cri-dockerd. The supported package has already been downloaded for this node. You must install it and enable both the service and socket units.

## Goal
Install cri-dockerd and enable `cri-docker.service` plus `cri-docker.socket`.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `docker.io` | Package | node | Already installed |
| `/root/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb` | File | node | pre-downloaded package |

## Requirements

| Field | Value |
|---|---|
| Install via | `dpkg -i` |
| .deb file | `/root/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb` |
| Enable service 1 | `cri-docker.service` |
| Enable service 2 | `cri-docker.socket` |
| CRI socket path | `/var/run/cri-dockerd.sock` |
| sysctl key 1 | `net.bridge.bridge-nf-call-iptables=1` |
| sysctl key 2 | `net.ipv4.ip_forward=1` |
| sysctl key 3 | `net.ipv6.conf.all.forwarding=1` |
