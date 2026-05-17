## Well done! 🎉
**What you practiced:** Adding a streaming sidecar to an existing Pod to make file-based logs visible via kubectl logs without modifying the application image.
**Why it matters on the CKA exam:** The sidecar pattern is a core Workloads topic. Pods are immutable — the delete-and-recreate pattern is the only way to add containers.
**CKA Domain:** Workloads & Scheduling
**Common mistake to avoid:** Trying to kubectl edit a running Pod to add a container — this is rejected. You must export, edit, delete, and re-apply.
**Further reading:** https://kubernetes.io/docs/concepts/workloads/pods/#how-pods-manage-multiple-containers
