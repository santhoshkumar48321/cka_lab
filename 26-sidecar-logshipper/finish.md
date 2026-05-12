## Well done!
**What you practiced:** Adding a log-shipping sidecar container to an existing Deployment to expose file-based logs via `kubectl logs`.
**Why it matters in CKA:** The sidecar pattern is a core Kubernetes concept tested in the Workloads domain — exam questions frequently ask you to add containers to existing Deployments without rebuilding the app image.
**CKA Domain:** Workloads & Scheduling
**Common mistake:** Forgetting to add the `volumeMount` to the existing main container — both containers must mount the same volume at `/opt`, otherwise the sidecar reads from an empty directory.
**Further reading:** https://kubernetes.io/docs/concepts/workloads/pods/#how-pods-manage-multiple-containers
