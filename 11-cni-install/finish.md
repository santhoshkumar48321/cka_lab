## Well done! 🎉

You practiced reinstalling a CNI plugin to restore pod networking after it had been removed — a real-world cluster recovery scenario.

**Why it matters on the CKA exam**: CNI installation and cluster troubleshooting are core Cluster Architecture topics. The exam may present a cluster where networking is broken and ask you to fix it.

**CKA Domain**: Cluster Architecture, Installation & Configuration

**Common mistake to avoid**: Installing Flannel (no NetworkPolicy support) or forgetting to edit the CIDR before applying custom-resources.yaml.

**Further reading**: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
