## Tasks

Install **Calico v3.27.4** using the Tigera operator manifest. This requires internet access.

### Step 1 — Install the Tigera Operator (Calico's installer)
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.4/manifests/tigera-operator.yaml
```

### Step 2 — Watch the operator start
```bash
kubectl get pods -n tigera-operator --watch
```

### Step 3 — (Optional) Install Calico custom resources for a self-managed cluster
```bash
curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.27.4/manifests/custom-resources.yaml
# Edit CIDR if needed, then:
kubectl create -f custom-resources.yaml
```

> **Exam note**: On the CKA exam the CNI URL is provided in the question. You only need to `kubectl apply/create -f <url>` and wait for nodes to go Ready. The `kubernetes.io` docs page for "Installing kubeadm" shows CNI install steps.

## Verify
```bash
# Check operator namespace exists:
kubectl get namespace tigera-operator
# Check pods in kube-system for any CNI components:
kubectl get pods -A | grep -E 'calico|tigera|flannel|cilium'
# Ultimately, nodes should be Ready:
kubectl get nodes
```
