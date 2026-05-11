## Scenario
⚠️ **When this scenario starts, the CNI plugin has been removed from the cluster.** Nodes will appear `NotReady` because pod networking is broken. Your task is to reinstall a policy-capable CNI to restore cluster networking.

## Goal
Install a CNI implementation that supports NetworkPolicy enforcement so all nodes return to `Ready` state.

## What you'll see when the lab starts
```
kubectl get nodes   →  NotReady
```

## Requirements
- Install a policy-capable CNI (Calico, Cilium, or Weave Net — **not** Flannel, which does not enforce NetworkPolicies)
- All nodes must return to `Ready` state after installation
- Verification accepts: `tigera-operator` namespace, `calico-system` namespace, or CNI pods/DaemonSet present in `kube-system`
