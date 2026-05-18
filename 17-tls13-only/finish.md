## Well done! 🎉

You practiced updating TLS settings in an nginx ConfigMap and restarting a Deployment to apply the change.

**Why it matters on the CKA exam**: TLS configuration changes are common, and remembering to restart workloads is often the difference between pass and fail.

**CKA Domain**: Services & Networking

**Common mistake to avoid**: Removing TLS 1.2 instead of adding it, or forgetting the rollout restart after the ConfigMap edit.

**Further reading**: https://kubernetes.io/docs/concepts/configuration/configmap/
