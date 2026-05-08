## Tasks

### Step 1 — Find the tainted node
```bash
kubectl get nodes -o custom-columns='NAME:.metadata.name,TAINTS:.spec.taints'
# OR
kubectl describe nodes | grep -A3 Taints
```

### Step 2 — Create pod `prod-pod` with toleration
```bash
TAINTED_NODE=$(kubectl get nodes \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{range .spec.taints[*]}{.key}={.value}:{.effect}{"\n"}{end}{end}' \
  | awk -F'\t' '/Env=Production:NoSchedule/{print $1; exit}')
echo "Tainted node: $TAINTED_NODE"

kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: prod-pod
spec:
  nodeName: ${TAINTED_NODE}
  tolerations:
  - key: "Env"
    operator: "Equal"
    value: "Production"
    effect: "NoSchedule"
  containers:
  - name: nginx
    image: nginx:latest
EOF
```

> **Note**: In a single-node cluster the control-plane node may also have a `node-role.kubernetes.io/control-plane:NoSchedule` taint. Using `nodeName` overrides the scheduler and places the pod directly, so you only need the toleration for `Env=Production:NoSchedule`.

## Verify
```bash
kubectl get pod prod-pod -o wide
kubectl describe pod prod-pod | grep -A5 Tolerations
kubectl get nodes -o custom-columns='NAME:.metadata.name,TAINTS:.spec.taints'
```
