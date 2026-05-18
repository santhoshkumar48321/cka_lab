## Well done! 🎉

**What you practiced:** Using nodeSelector to pin a Pod to nodes with specific labels.
**Why it matters on the CKA exam:** nodeSelector is the simplest scheduling constraint — the exam tests whether you know where to place it in the Pod spec.
**CKA Domain:** Workloads & Scheduling
**Common mistake to avoid:** Putting the nodeSelector at the wrong level — it belongs under spec.nodeSelector (Pod level), not spec.template.spec (Deployment level mistake) or inside the container spec.
**Further reading:** https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector
