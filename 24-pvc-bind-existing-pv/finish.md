## Well done!
**What you practiced:** Creating a PVC to bind a pre-existing retained PV, then mounting it into a running Deployment without deleting the Deployment.
**Why it matters in CKA:** PVC binding and Deployment modification are core storage topics — understanding how to bind to a specific PV using storageClassName matching is frequently tested.
**CKA Domain:** Storage
**Common mistake:** Using a different storageClassName than the PV — the PVC must use `storageClassName: manual` to match the PV and trigger binding.
**Further reading:** https://kubernetes.io/docs/concepts/storage/persistent-volumes/
