## Well done!
**What you practiced:** Modifying an existing Deployment to add a named container port, then creating a NodePort Service to expose it externally.
**Why it matters in CKA:** The CKA exam tests both Deployment modification and Service creation — the key constraint is modifying in-place rather than deleting and recreating.
**CKA Domain:** Services & Networking
**Common mistake:** Deleting and recreating the Deployment instead of editing it — always use `kubectl edit` or `kubectl patch` to modify existing resources.
**Further reading:** https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
