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

### Step 4 — Validate for kubeadm (optional)
```bash
# Verify the socket is ready for kubeadm:
cri-dockerd --version
```

## Hints
```bash
# Check the .deb is present:
ls -lh /root/cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb

# After install, both systemd units should exist:
systemctl list-unit-files | grep cri-docker
```

## Verify
```bash
dpkg -l | grep cri-dockerd
systemctl is-active cri-docker.service
systemctl is-active cri-docker.socket
ls -la /var/run/cri-dockerd.sock
```
