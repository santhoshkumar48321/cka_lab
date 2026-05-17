## Well done! 🎉
**What you practiced:** Applying a taint to a node and scheduling a pod with a matching toleration so it can land on the reserved node.
**Why it matters on the CKA exam:** Taints and tolerations are a Workloads scheduling topic — the exact key, value, and effect must match precisely.
**CKA Domain:** Workloads & Scheduling
**Common mistake to avoid:** Getting the taint key wrong — it is case-sensitive. `Env=Production:NoSchedule` is different from `env=production:NoSchedule`.
**Further reading:** https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
