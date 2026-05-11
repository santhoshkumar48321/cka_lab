## Well done! 🎉

You practiced discovering CRDs and extracting schema documentation with `kubectl explain` — essential exam survival skills.

**Why it matters on the CKA exam**: The exam allows `kubectl explain` and the Kubernetes docs. Knowing how to navigate CRD schemas quickly is critical when encountering unfamiliar resource types.

**CKA Domain**: Cluster Architecture, Installation & Configuration

**Common mistake to avoid**: Relying on the short name when it is not registered — always have the full `resource.group` form as a fallback (e.g., `virtualservices.networking.istio.io.spec.hosts`).

**Further reading**: https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/
