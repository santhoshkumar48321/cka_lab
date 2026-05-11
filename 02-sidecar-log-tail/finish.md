## Well done! 🎉

You practiced the sidecar log-streaming pattern — adding a secondary container to expose file-based logs via `kubectl logs`.

**Why it matters on the CKA exam**: The sidecar pattern is a core Kubernetes concept tested in the Workloads domain. Exam questions frequently ask you to add containers to existing Deployments without rebuilding the app image.

**CKA Domain**: Workloads & Scheduling

**Common mistake to avoid**: Forgetting to add the `volumeMount` to the **existing** main container — both containers must mount the same volume at `/var/log`, otherwise the sidecar reads from an empty directory and produces no output.

**Further reading**: https://kubernetes.io/docs/concepts/workloads/pods/#how-pods-manage-multiple-containers
