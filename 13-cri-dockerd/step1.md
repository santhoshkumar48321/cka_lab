## Tasks

### Step 1 — Install cri-dockerd from the pre-downloaded .deb
```bash
dpkg -i ~/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb
```

### Step 2 — Enable and start the cri-docker service
```bash
# Enable so it starts on reboot, then start it now:
systemctl enable cri-docker
systemctl start cri-docker
systemctl is-active cri-docker
```

> **Tip**: Use `systemctl enable --now cri-docker` to enable and start in one command.

### Step 3 — Apply required sysctl values
```bash
# Apply all four required parameters:
sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.netfilter.nf_conntrack_max=262144

# Persist them across reboots:
cat >> /etc/sysctl.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.ipv6.conf.all.forwarding=1
net.ipv4.ip_forward=1
net.netfilter.nf_conntrack_max=262144
EOF
```

## Verify
```bash
dpkg -l | grep cri-dockerd
systemctl is-active cri-docker
sysctl net.bridge.bridge-nf-call-iptables net.ipv6.conf.all.forwarding net.ipv4.ip_forward net.netfilter.nf_conntrack_max
```
