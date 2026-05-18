## Well done! 🎉

You practiced creating a PriorityClass and patching a Deployment to use it — a common task when managing workload scheduling priorities.

**Why it matters on the CKA exam**: PriorityClasses affect pod scheduling order and preemption. Exam questions may ask you to assign a specific priority value relative to existing classes.

**CKA Domain**: Workloads & Scheduling

**Common mistake to avoid**: Using a ClusterRoleBinding instead of `kubectl patch`, or calculating the wrong value (it must be highest minus 1).

**Further reading**: https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/
