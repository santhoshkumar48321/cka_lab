## Goal
Install a CNI that enables pod networking and supports NetworkPolicy enforcement.

## Requirements
- Install a policy-capable CNI implementation (Calico, Flannel, Cilium, or Weave).
- Successful install indicators accepted by verification:
  - Namespace `tigera-operator`, or
  - Namespace `calico-system`, or
  - Matching CNI pods in namespace `kube-system`, or
  - Matching CNI DaemonSet present cluster-wide.
