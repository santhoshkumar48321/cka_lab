## Prerequisites (run first)
```bash
service docker start && docker info
```

## Tasks

1. Install cri-dockerd from the pre-downloaded package.
2. Reload systemd and enable both `cri-docker.socket` and `cri-docker.service`.
3. Apply required sysctl networking settings persistently.

⚠️ Always run `systemctl daemon-reload` after `dpkg -i` before enabling the service.

## Inspect existing resources

```bash
docker info | head -5
ls -lh /root/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb
systemctl list-unit-files | grep cri-docker || true
```

## Solution

```bash
# 1. Install
# (post-install service startup is intentionally suppressed in this lab setup)
dpkg -i /root/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb

# 2. Reload systemd to pick up new unit files
systemctl daemon-reload

# 3. Enable socket first, then service
systemctl enable --now cri-docker.socket
systemctl enable --now cri-docker.service

# 4. Apply sysctl settings persistently
tee /etc/sysctl.d/99-cri-dockerd.conf <<'YAML'
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
YAML
sysctl --system
```

## Verify

```bash
cri-dockerd --version
systemctl is-active cri-docker.service
systemctl is-active cri-docker.socket
test -S /var/run/cri-dockerd.sock && echo "socket OK"
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.ipv4.ip_forward
sysctl net.ipv6.conf.all.forwarding
```
