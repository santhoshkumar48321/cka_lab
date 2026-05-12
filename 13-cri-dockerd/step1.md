## Tasks

### Step 1 — Install cri-dockerd from the pre-downloaded .deb
```bash
dpkg -i /root/cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb
```

### Step 2 — Enable and start BOTH cri-docker services
```bash
# Enable and start the main service:
systemctl enable --now cri-docker.service

# Enable and start the socket:
systemctl enable --now cri-docker.socket
```

### Step 3 — Verify both services are active
```bash
systemctl is-active cri-docker.service
systemctl is-active cri-docker.socket
ls -la /var/run/cri-dockerd.sock
```

### Step 4 — Apply required sysctl values
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
systemctl is-active cri-docker.service
systemctl is-active cri-docker.socket
ls -la /var/run/cri-dockerd.sock
sysctl net.bridge.bridge-nf-call-iptables net.ipv6.conf.all.forwarding net.ipv4.ip_forward net.netfilter.nf_conntrack_max
```
