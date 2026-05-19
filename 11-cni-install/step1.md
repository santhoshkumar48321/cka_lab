## Tasks

> ⏱ **Calico takes 2–3 minutes to fully initialise.** Watch progress with:
> `kubectl get pods -n tigera-operator -w`
> Do NOT click CHECK until all pods show Running.

Install **Calico v3.27.4** using the Tigera operator manifest.

## Step 0 — Read cluster CIDR (MUST do this before applying custom-resources.yaml)
```bash
cat /root/cluster-cidr.txt
# OR: grep 'cluster-cidr' /etc/kubernetes/manifests/kube-controller-manager.yaml
# Update the cidr: field in custom-resources.yaml to match before applying
```

### Step 1 — Install the Tigera Operator
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.4/manifests/tigera-operator.yaml
```

### Step 2 — Apply custom resources
```bash
curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.27.4/manifests/custom-resources.yaml
vi custom-resources.yaml
kubectl create -f custom-resources.yaml
```

### Step 3 — Wait for pods and node readiness
```bash
kubectl get pods -n tigera-operator -w
kubectl get nodes -w
```

## Step 4 — Restart kubelet (exam requires this)
```bash
systemctl restart kubelet
```

## Verify
```bash
kubectl get namespace tigera-operator
kubectl get pods -n tigera-operator
kubectl get nodes
```
