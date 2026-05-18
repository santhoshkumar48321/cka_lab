## Well done! 🎉

**What you practiced:** Creating a PVC that binds to a retained PV, then modifying an existing Deployment to mount it without deleting the Deployment.
**Why it matters on the CKA exam:** PVC binding and Deployment modification are core Storage topics — mismatching the storageClassName is a very common failure.
**CKA Domain:** Storage
**Common mistake to avoid:** Setting a storageClassName that doesn't match the PV — use storageClassName: manual to match the pre-created web-pv.
**Further reading:** https://kubernetes.io/docs/concepts/storage/persistent-volumes/
