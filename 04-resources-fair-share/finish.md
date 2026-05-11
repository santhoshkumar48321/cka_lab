## Well done! 🎉

You practiced setting CPU and memory requests/limits on both init containers and main containers to ensure fair resource allocation across pods.

**Why it matters on the CKA exam**: Resource management is a core scheduling topic. Exam questions frequently ask you to add or modify resource requests/limits on Deployments, and often include init containers as a trap for the unprepared.

**CKA Domain**: Workloads & Scheduling

**Common mistake to avoid**: Only setting resources on the main container and forgetting `initContainers` — the verify check inspects both, and the scheduler accounts for init container resource requests during scheduling.

**Further reading**: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
