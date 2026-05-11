## Well done! 🎉

You practiced reinstalling a CNI plugin to restore pod networking after it had been removed — a real-world cluster recovery scenario.

**Why it matters on the CKA exam**: CNI installation and cluster troubleshooting are core Cluster Architecture topics. The exam may present a cluster where networking is broken and ask you to fix it.

**CKA Domain**: Cluster Architecture, Installation & Configuration

**Common mistake to avoid**: Installing Flannel when the task requires NetworkPolicy support — Flannel does not enforce NetworkPolicies. Always choose Calico, Cilium, or Weave Net when policy enforcement is required.

**Further reading**: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
