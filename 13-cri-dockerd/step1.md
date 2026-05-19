## Tasks

1. Ensure the Docker daemon is running.
2. Install cri-dockerd from the pre-downloaded package.
3. Reload systemd and enable both `cri-docker.socket` and `cri-docker.service`.
4. Apply required sysctl networking settings persistently.

⚠️ The pre-downloaded package is v0.3.20 which uses Docker API 1.44 natively — compatible with Docker daemon v29+.

⚠️ Always run `systemctl daemon-reload` after `dpkg -i` before enabling the service.

## Inspect existing resources

```bash
docker info | head -5
ls -lh /root/cri-dockerd.deb
systemctl list-unit-files | grep cri-docker || true
```

## Solution

```bash
# 1. Install (ignore the "Could not execute systemctl" postinst warning)
dpkg -i /root/cri-dockerd.deb

# 2. Reload systemd to pick up new unit files
systemctl daemon-reload

# 3. Enable socket first, then service
systemctl enable --now cri-docker.socket
systemctl enable --now cri-docker.service

# 4. Apply sysctl settings persistently
tee /etc/sysctl.d/99-cri-dockerd.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
EOF
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
