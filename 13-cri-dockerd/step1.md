## Tasks

1. Ensure the Docker daemon is running.
2. Install cri-dockerd from the pre-downloaded package.
3. Enable and start both `cri-docker.service` and `cri-docker.socket`.
4. Apply required sysctl networking settings.

⚠️ Do NOT use v0.3.9 — it uses Docker API 1.43 which is incompatible with this cluster's Docker daemon (requires ≥ 1.44).

## Inspect existing resources

```bash
service docker start && docker info
ls -lh /root/cri-dockerd.deb
systemctl list-unit-files | grep cri-docker || true
```

## Skeleton (fill in the blanks)

```bash
dpkg -i /root/cri-dockerd.deb
systemctl enable --now cri-docker.service
systemctl enable --now cri-docker.socket

sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
```

## Verify

```bash
cri-dockerd --version
systemctl is-active cri-docker.service
systemctl is-active cri-docker.socket
test -S /var/run/cri-dockerd.sock
```
