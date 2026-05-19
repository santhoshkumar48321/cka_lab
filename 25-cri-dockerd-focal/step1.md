## Tasks

1. Ensure the Docker daemon is running.
2. Reset any previous kubeadm state (safe if none exists).
3. Run `kubeadm init` using the cri-dockerd socket and save output to `/root/kubeadm-init.log`.

## Step 1 — Start Docker
```bash
service docker start && docker info
```

## Step 2 — Reset kubeadm (ignore errors if not initialized)
```bash
kubeadm reset -f 2>/dev/null || true
```

## Step 3 — Initialize the cluster with cri-dockerd
```bash
kubeadm init --cri-socket unix:///var/run/cri-dockerd.sock \
  --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=all \
  | tee /root/kubeadm-init.log
```

## Verify
```bash
test -s /root/kubeadm-init.log
grep -E "kubeadm join" /root/kubeadm-init.log
grep -E "cri-dockerd|unix:///var/run/cri-dockerd.sock" /root/kubeadm-init.log
```
