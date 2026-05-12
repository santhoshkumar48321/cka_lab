## Well done!
**What you practiced:** Installing cri-dockerd from a .deb package and enabling both the service and socket units needed for kubeadm CRI integration.
**Why it matters in CKA:** The CKA exam tests cluster setup — cri-dockerd is the bridge between Docker Engine and Kubernetes CRI, and both the service and socket must be active.
**CKA Domain:** Cluster Architecture, Installation & Configuration
**Common mistake:** Only enabling cri-docker.service and forgetting cri-docker.socket — kubeadm requires the socket file at /var/run/cri-dockerd.sock which is created by the socket unit.
**Further reading:** https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker
