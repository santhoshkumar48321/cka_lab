## Well done! 🎉

You practiced creating an HPA with a scale-down stabilization window to prevent flapping after load spikes.

**Why it matters on the CKA exam**: HPA configuration is tested in the Workloads domain. The `behavior` field is a common trap because it requires `autoscaling/v2`.

**CKA Domain**: Workloads & Scheduling

**Common mistake to avoid**: Using `autoscaling/v1` (no `behavior` field) or forgetting the `behavior.scaleDown` nesting.

**Further reading**: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
