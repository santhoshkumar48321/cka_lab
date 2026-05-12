## Scenario
Your team needs to configure Docker Engine as a CRI-compatible runtime using cri-dockerd. The .deb package for Ubuntu Focal has been downloaded to /root. You must install it and enable both the service and socket units so the runtime is available for kubeadm.

## Goal
Install cri-dockerd from the pre-downloaded .deb, enable both cri-docker.service and cri-docker.socket, and verify the CRI socket exists at /var/run/cri-dockerd.sock.

## What exists when the node starts

| Resource | Notes |
|---|---|
| `docker.io` | Already installed |
| `/root/cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb` | Downloaded and ready to install |

## Requirements

| Field | Value |
|---|---|
| Install via | `dpkg -i` |
| .deb file | `/root/cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb` |
| Enable service 1 | `cri-docker.service` |
| Enable service 2 | `cri-docker.socket` |
| CRI socket path | `/var/run/cri-dockerd.sock` |
| Validation | `kubeadm init --cri-socket unix:///var/run/cri-dockerd.sock` must be valid |
